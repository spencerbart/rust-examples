variable "repo_url" {
  type = string
}

resource "aws_ecs_cluster" "my_cluster" {
  name = "poc_cluster"
}

resource "aws_ecs_task_definition" "rust_poc_task" {
  family                   = "rust_poc_task"
  container_definitions    = <<DEFINITION
    [
        {
            "name": "rust_poc_task",
            "image": "${var.repo_url}",
            "essential": true,
            "portMappings": [
                {
                    "containerPort": 8000,
                    "hostPort": 8000
                }
            ],
            "memory": 512,
            "cpu": 256
        }
    ]
    DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsAccess" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_role_policy_attachment" "ecrAccess" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
}

resource "aws_ecs_service" "rust_poc_service" {
    name = "rust_poc_service"
    cluster = "${aws_ecs_cluster.my_cluster.id}"
    task_definition = "${aws_ecs_task_definition.rust_poc_task.arn}"
    launch_type = "FARGATE"
    desired_count = 1

    network_configuration {
        subnets = ["${aws_default_subnet.default_subnet_a.id}"]
        assign_public_ip = true
    }
}

resource "aws_default_vpc" "default_vpc" {

}

resource "aws_default_subnet" "default_subnet_a" {
    availability_zone = "us-east-1a"
}