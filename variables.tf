variable "project_name" {
  description = "Nome do projeto, usado para nomear os recursos."
  type        = string
  default     = "baiters-burguer"
}

variable "nlb_arn" {
  description = "O ARN do NLB"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "O ID da VPC existente (ex: vpc-0123abcd)."
  type        = string
}

variable "nlb_dns_name" {
  description = "Nome do NLB"
  type        = string
}