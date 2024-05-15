locals {
  name = "${var.Project_name}-${var.Environment}"
 private_subnet_id = element(split(",",data.aws_ssm_parameter.private_subnet_id.value),0)
 current_time = formatdate("YYYY-MM-DD-hh-mm",timestamp())
}