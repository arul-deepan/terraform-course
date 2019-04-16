resource "aws_instance" "example" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = "${aws_subnet.main-public-1.id}"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]

  # the public SSH key
  key_name = "${aws_key_pair.mykeypair.key_name}"

  # user data
	user_data = <<EOF
		#!/bin/bash
		yum update -y
		amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
		yum install -y httpd mariadb-server
		systemctl start httpd
		systemctl enable httpd
		usermod -a -G apache ec2-user
		chown -R ec2-user:apache /var/www
		chmod 2775 /var/www
		find /var/www -type d -exec chmod 2775 {} \;
		find /var/www -type f -exec chmod 0664 {} \;
		echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
		EOF
}
resource "aws_ebs_volume" "ebs-volume-1" {
    availability_zone = "eu-west-1a"
    size = 20
    type = "gp2" 
    tags {
        Name = "extra volume data"
    }
}

resource "aws_volume_attachment" "ebs-volume-1-attachment" {
  device_name = "${var.INSTANCE_DEVICE_NAME}"
  volume_id = "${aws_ebs_volume.ebs-volume-1.id}"
  instance_id = "${aws_instance.example.id}"
}

