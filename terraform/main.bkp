resource "aws_lb_target_group" "catalogue" {
  name_prefix    = "target"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value
  deregistration_delay = 60
   health_check {
      healthy_threshold   = 2
      interval            = 10
      unhealthy_threshold = 3
      timeout             = 5
      path                = "/health"
      port                = 8080
      matcher             = "200-299" 
  }
}
module "catalogue"{
    source = "terraform-aws-modules/ec2-instance/aws"
    name = "${local.name}-${var.tags.Component}"
    ami = data.aws_ami.centos8.id
    instance_type          = "t2.micro"
    vpc_security_group_ids = [data.aws_ssm_parameter.catalogue-security_group_id.value]
    subnet_id              = element(split(",", data.aws_ssm_parameter.private_subnet_id.value), 0)
    iam_instance_profile = "terraform_admin_access"
    tags = merge(var.common_tags,var.tags)
    }
resource "null_resource" "catalogue" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.catalogue.id
  }
    connection {
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
    host     = module.catalogue.private_ip
  }
provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }
provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh catalogue dev ${var.app_version}",
    ]
  }
}
resource "aws_ec2_instance_state" "stop-catalogue" {
  instance_id = module.catalogue.id
  state       = "stopped"
   depends_on = [
    null_resource.catalogue
  ]
}
resource "aws_ami_from_instance" "catalogue" {
  name               = "${local.name}-${var.tags.Component}-${local.current_time}"
  source_instance_id = module.catalogue.id
  depends_on = [
    aws_ec2_instance_state.stop-catalogue
  ]
}
resource "null_resource" "catalogue-delete" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.catalogue.id
  }
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${module.catalogue.id}"
  }
depends_on = [
    aws_ami_from_instance.catalogue
  ]
}
resource "aws_launch_template" "catalogue" {
  name_prefix  = "${local.name}-${var.tags.Component}"
  image_id = aws_ami_from_instance.catalogue.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue-security_group_id.value]
  update_default_version = true
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${local.name}-${var.tags.Component}"
    }
  }
}
resource "aws_autoscaling_group" "catalogue" {
  name                      = "${local.name}-${var.tags.Component}"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 2
  launch_template {
    id      = aws_launch_template.catalogue.id
    version = aws_launch_template.catalogue.latest_version
  }
  vpc_zone_identifier       = split(",",data.aws_ssm_parameter.private_subnet_id.value)
  target_group_arns = [ aws_lb_target_group.catalogue.arn ]
 instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }
  tag {
    key                 = "Name"
    value               = "${local.name}-${var.tags.Component}"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
}
resource "aws_autoscaling_policy" "catalogue" {
    name                   = "${local.name}-${var.tags.Component}"
    autoscaling_group_name = aws_autoscaling_group.catalogue.name
    policy_type            = "TargetTrackingScaling"
    target_tracking_configuration {
      predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 5.0
  }
}

resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = data.aws_ssm_parameter.load_balancer_arn.value
  priority     = 10
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }
  condition {
    host_header {
      values = ["${var.tags.Component}.app-${var.Environment}.${var.zone_name}"]
    }
  }
}

