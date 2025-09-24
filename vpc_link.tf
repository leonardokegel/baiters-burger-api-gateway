resource "aws_api_gateway_vpc_link" "eks_nlb_link" {
  name        = "${var.project_name}-vpc-link"
  description = "VPC Link para o NLB do cluster EKS"

  target_arns = [var.nlb_arn]

  tags = {
    Project = var.project_name
  }
}