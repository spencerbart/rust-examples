cd terraform1

terraform destroy -auto-approve

cd ../terraform2

terraform destroy -var="repo_url=$ECR_repo_url" -auto-approve