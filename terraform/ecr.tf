resource "aws_ecr_repository" "app" {
  name         = "devops-bootcamp/final-project-kumanan"
  force_delete = true # lets `terraform destroy` remove the repo even when it holds images

  image_scanning_configuration {
    scan_on_push = true # not graded — good practice
  }

  tags = { Project = "devops-bootcamp-final-project" }
}
