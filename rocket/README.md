# rustPoc
Requirements:
-AWS Credentials (AWS CLI is the easiest way to manage these)
-Terraform
-Docker

1. Set your AWS credentials using AWS CLI or ENV variables
2. Modify and put Dockerfile (example provided) in project directory
3. Modify and run the docker_push_to_aws.sh script.  You will need to change the path to your project...

That should be it! Let me know if there are any issues... There probably will be...
Don't forget to destroy the resources unless you want to leave it up!

To access your service, go to Amazon ECS -> Clusters -> Your cluster -> tasks -> your task -> eni link -> public dns should be at eni.

Future improvements are:
-routing to a specific dns address
-load balancing
-possible api gateway?
-and much much more.