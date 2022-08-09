cd ../terraform1

terraform init

terraform apply -auto-approve

ECR_repo_url=$(cat terraform.tfstate | jq -r '.resources[0].instances[0].attributes.repository_url')

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_repo_url

# Change this to your project
cd ../rust_poc

docker build -t rust_deployment_repo .

docker tag rust_deployment_repo:latest 198471760387.dkr.ecr.us-east-1.amazonaws.com/rust_deployment_repo:latest

docker push 198471760387.dkr.ecr.us-east-1.amazonaws.com/rust_deployment_repo:latest

cd ../terraform2

terraform init

terraform apply -var="repo_url=$ECR_repo_url" -auto-approve

cd ../