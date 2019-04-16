data "template_file" "shell-script" {
  template = "${file("scripts/install.sh")}"
}
