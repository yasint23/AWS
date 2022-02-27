#//////////////////RDS DB SUBNET GROUP////////////

resource "aws_db_subnet_group" "rds_subnet" {
  name       = var.db_subnet
  subnet_ids = [aws_subnet.Private1A.id, aws_subnet.Private1B.id]

}

#//////////////////RDS DB INSTANCE////////////

resource "aws_db_instance" "aws-capstone-RDS" {
  identifier              = var.db_instance_identifier
  allocated_storage       = var.db_allocated_storage
  max_allocated_storage   = var.db_max_allocated_storage
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  skip_final_snapshot     = true
  apply_immediately       = true
  vpc_security_group_ids  = [aws_security_group.RDS-sg.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet.id
  publicly_accessible     = false
  port                    = var.db_port
  backup_retention_period = var.db_backup_retention_period
  backup_window           = var.db_backup_window
  maintenance_window      = var.db_maintenance_window
  name                    = var.db_name
  username                = var.db_username
  password                = var.db_password
  parameter_group_name    = var.db_parameter_group_name

  tags = {
    Name = "${var.env_prefix}-RDS-instance"
  }

}

#////////////////FAILOVER S3 BUCKET//////////////

resource "aws_s3_bucket" "failover-bucket" {
  bucket        = var.failover_bucket
  acl           = var.failover_acl
  force_destroy = true
  policy        = file("policy2.json")

 website {
    index_document = var.blog_index_document
  }
}

resource "aws_s3_bucket_object" "object1" {
  for_each      = fileset("myfiles/", "*")
  bucket        = aws_s3_bucket.failover-bucket.id
  key           = each.value
  source        = "myfiles/${each.value}"
  etag          = filemd5("myfiles/${each.value}")
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "failover-public-access" {
  bucket = var.failover_bucket

  block_public_acls   = false
  block_public_policy = false
}
#////////////////BLOG WEB SİTE'S S3 BUCKET//////////////

resource "aws_s3_bucket" "awscapstonesgaskinblog" {
  bucket        = var.blog_bucket
  acl           = var.blog_acl
  policy        = file("policy.json")
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "blog-public-access" {
  bucket = var.blog_bucket

  block_public_acls   = false
  block_public_policy = false
}

#////////////////NAT INSTANCE//////////////
resource "aws_instance" "Capstone-NAT-instance" {
  ami                         = var.nat_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.Public1A.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.NAT-sg.id]
  source_dest_check           = false
  key_name                    = var.key_name

  tags = {
    Name = "${var.env_prefix}-NAT-instance"
  }

}

#////////////////LAUNCH TEMPLATE//////////////

resource "aws_launch_template" "Capstone-LT" {
  name                    = "${var.env_prefix}-LT"
  image_id                = var.image_id
  instance_type           = var.instance_type
  key_name                = var.key_name
  disable_api_termination = true
  iam_instance_profile {
    name = aws_iam_instance_profile.EC2_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.WebServer-sg.id]
  }


  tag_specifications {
    resource_type = var.LT_resource_type
    tags = {
      Name = "${var.env_prefix}-LT"
    }
  }

  user_data = filebase64("user_data.sh")

}

#////////////////IAM ROLE EC2-S3 FULL ACCESS//////////////

resource "aws_iam_role" "aws_capstone_EC2_S3_Full_Access" {
  name               = "${var.env_prefix}-EC2-S3-Fullaccess"
  assume_role_policy = file("assumerolepolicy.json")
}

resource "aws_iam_instance_profile" "EC2_profile" {
  name = "${var.env_prefix}-profile2"
  role = aws_iam_role.aws_capstone_EC2_S3_Full_Access.name
}

resource "aws_iam_policy" "S3-Policy" {
  name   = "${var.env_prefix}-EC2-S3-policy"
  policy = file("policys3bucket.json")
}

resource "aws_iam_policy_attachment" "role-attach" {
  name       = "${var.env_prefix}-s3-role-attach"
  roles      = ["${aws_iam_role.aws_capstone_EC2_S3_Full_Access.name}"]
  policy_arn = aws_iam_policy.S3-Policy.arn
}

#/////////////////AMAZON CERTIFICATE MANAGER///////////

data "aws_acm_certificate" "amazon_issued" {
  domain      = var.acm_domain
  types       = var.acm_types
  most_recent = true
}

#///////////////ELASTIC LOAD BALANCER///////////////

resource "aws_lb_target_group" "Capstone-tg" {
  vpc_id           = aws_vpc.Capstone-VPC.id
  name             = "${var.env_prefix}-tg"
  target_type      = var.lb_target_type  
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"

  health_check {
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 20
    timeout             = 5
    matcher             = "200"
  }
}

resource "aws_lb" "Capstone-ELB" {
  name               = "${var.env_prefix}-ELB"
  internal           = false
  load_balancer_type = var.load_balancer_type 
  security_groups    = [aws_security_group.ELB-sg.id]
  subnets            = [aws_subnet.Public1A.id, aws_subnet.Public1B.id]
}

resource "aws_lb_listener" "Capstone-listener-80" {
  load_balancer_arn = aws_lb.Capstone-ELB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = var.listener_http_type
    target_group_arn = aws_lb_target_group.Capstone-tg.arn
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "Capstone-listener-443" {
  load_balancer_arn = aws_lb.Capstone-ELB.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.amazon_issued.arn

  default_action {
    type             = var.listener_https_type
    target_group_arn = aws_lb_target_group.Capstone-tg.arn
  }
}

#//////////////////AUTO SCALING GROUP///////////////

resource "aws_autoscaling_group" "Capstone-asg" {
  vpc_zone_identifier       = [aws_subnet.Private1A.id, aws_subnet.Private1B.id]
  health_check_type         = var.ASG_health_check_type    
  desired_capacity          = 2
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  target_group_arns         = [aws_lb_target_group.Capstone-tg.arn]

  launch_template {
    id      = aws_launch_template.Capstone-LT.id
    version = "$Latest"
  }
}

#///////////////CLOUDFRONT IN FRONT OF ELB//////////////

resource "aws_cloudfront_distribution" "Capstone-ELB-cloudfront" {
  origin {
    domain_name = aws_lb.Capstone-ELB.dns_name
    origin_id   = aws_lb.Capstone-ELB.dns_name

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = var.cf_origin_protocol_policy
      origin_ssl_protocols   = var.cf_origin_ssl_protocols
    }
  }

  enabled = true
  comment = "${var.env_prefix}-CF-ELB"
  aliases = var.cf_aliases

  default_cache_behavior {
    compress         = true
    allowed_methods  = var.cf_allowed_methods
    cached_methods   = var.cf_cached_methods
    target_origin_id = aws_lb.Capstone-ELB.dns_name

    forwarded_values {
      query_string            = false
      headers                 = ["*"]
      query_string_cache_keys = []

      cookies {
        forward = var.cf_forward
      }
    }

    viewer_protocol_policy = var.cf_viewer_protocol_policy 
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  ordered_cache_behavior {
    path_pattern     = var.cf_path_pattern
    allowed_methods  = var.cf_cached_methods
    cached_methods   = var.cf_cached_methods
    target_origin_id = aws_lb.Capstone-ELB.dns_name


    forwarded_values {
      query_string            = false
      headers                 = ["*"]
      query_string_cache_keys = []

      cookies {
        forward = var.cf_forward
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = var.cf_viewer_protocol_policy
  }


  price_class = var.cf_price_class

  restrictions {
    geo_restriction {
      restriction_type = var.cf_restriction_type
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.amazon_issued.arn
    ssl_support_method       = var.cf_ssl_support_method
    minimum_protocol_version = var.cf_minimum_protocol_version
  }
}

#///////////////////////ROUTE 53//////////////

resource "aws_route53_health_check" "Capstone-health-check" {
  fqdn              = aws_cloudfront_distribution.Capstone-ELB-cloudfront.domain_name
  port              = 80
  type              = var.rt53_type
  resource_path     = var.rt53_resource_path
  failure_threshold = var.rt53_failure_threshold
  request_interval  = var.rt53_request_interval

  tags = {
    Name = "${var.env_prefix}-route53-hc"
  }
}
#///////////////data hosted zone////////////////
data "aws_route53_zone" "Capstone-hosted-zone" {
  name         = var.domain_name 
  private_zone = false
}

#////////////////records//////////

resource "aws_route53_record" "route53-primary" {
  zone_id = data.aws_route53_zone.Capstone-hosted-zone.zone_id
  name    = "www.${data.aws_route53_zone.Capstone-hosted-zone.name}"
  type    = var.rt53_record_type 
  set_identifier = var.rt53_set_identifier

  failover_routing_policy {
     type = var.rt53_failover_type
  }

   alias {
    name      = aws_cloudfront_distribution.Capstone-ELB-cloudfront.domain_name
    zone_id =  aws_cloudfront_distribution.Capstone-ELB-cloudfront.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "route53-secondary" {
  zone_id = "${data.aws_route53_zone.Capstone-hosted-zone.zone_id}"
  name    = var.domain_name
  type    = var.rt53_record_type 
  set_identifier = var.rt53_failover_type
  
  failover_routing_policy {
     type = var.rt53_failover_secondary_type 
  }
   alias {
        name = aws_s3_bucket.failover-bucket.website_domain
        zone_id = aws_s3_bucket.failover-bucket.hosted_zone_id
        evaluate_target_health = false      
  }
}


#////////////////////DYNAMODB TABLE////////////////

resource "aws_dynamodb_table" "Capstone-Dynamodb" {
  name           = "${var.env_prefix}-Dynamodb"
  billing_mode     = var.dy_billing_mode
  read_capacity  = 20
  write_capacity = 20
  hash_key       = var.dy_hash_key
  
  attribute {
    name = var.dy_hash_key
    type = var.dy_type
  }
   tags = {
    Name = "${var.env_prefix}-dynamodb"
  }
}

#////////////////////LAMBDA FUNCTION/////////////////

resource "aws_iam_role" "Capstone_role_lambda" {
  name = "${var.env_prefix}-lambda"
  assume_role_policy = file("lambdapolicy.json")
}

resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  role       =  aws_iam_role.Capstone_role_lambda.name
  count      = "${length(var.lambda_policy_arn)}"
  policy_arn = "${var.lambda_policy_arn[count.index]}"
}

locals {
  lambda_zip_location = "outputs/lambda.zip"
}

data "archive_file" "Capstone-lambda" {
  type        = var.archive_type 
  source_file = var.lambda_source_file 
  output_path = "${local.lambda_zip_location}"
}

resource "aws_lambda_function" "Capstone-lambda" {
  filename      = var.lambda_filename 
  function_name = var.lambda_function_name 
  role          = "${aws_iam_role.Capstone_role_lambda.arn}"
  handler       = var.handler 
  #source_code_hash = filebase64sha256("lambda.zip")

  runtime = var.runtime

  vpc_config  {
    subnet_ids = [
      "${aws_subnet.Private1A.id}", 
      "${aws_subnet.Private1B.id}",
      "${aws_subnet.Public1A.id}",
      "${aws_subnet.Public1B.id}",
  ]
    security_group_ids = ["${aws_security_group.Lambda_sg.id}"]
  }
}

#////////////////////LAMBDA S3 TRIGGER///////////////

resource "aws_s3_bucket_notification" "Capstone-lambda-s3-trigger" {
bucket = "${aws_s3_bucket.awscapstonesgaskinblog.id}"

lambda_function {
lambda_function_arn = "${aws_lambda_function.Capstone-lambda.arn}"
events              = var.s3_trigger_events  
filter_prefix       = var.s3_trigger_filter_prefix       
    }
}

resource "aws_lambda_permission" "capstone-lambda-permission" {
statement_id  = var.lambda_trigger_statement_id 
action        = var.lambda_trigger_action 
function_name = "${aws_lambda_function.Capstone-lambda.function_name}"
principal = var.lambda_trigger_principal
source_arn = "arn:aws:s3:::${aws_s3_bucket.awscapstonesgaskinblog.id}"
}
