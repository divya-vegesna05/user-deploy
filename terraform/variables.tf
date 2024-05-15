variable "Project_name" {
  type = string
  default = "roboshop"
}
variable "Environment" {
  type = string
  default = "dev"
}
variable "common_tags" {
  type = map
  default = {
    Project = "roboshop"
    Environment = "dev"
    Terraform = "true"
  }
}
variable "tags" {
  type = map
  default = {
    Component = "user"
  }
}
variable "vpc_security_group_id" {
  type = list
  default = []
}
variable "subnet_id" {
  type = string
  default = ""
}
variable "zone_name" {
  type = string
  default = "jasritha.tech"
}
variable "zone_id" {
  type = string
  default = "Z04879463GXQ7LRPO48K6"
}
variable "app_version" {
 type = string 
}
variable "iam_instance_profile" {
  default = "terraform_admin_access"
}
variable "priority" {
  default = 10
}