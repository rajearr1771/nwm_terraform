provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "instance" {
 count = 2
 ami = "ami-0565af6e282977273"
 instance_type = "t2.micro"
 key_name = "devops"
  tags = {
    Name = "for_ansible"
  }
 provisioner "remote-exec"{
  inline=["sudo apt-get -y install python"]
  connection{
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("/home/ubuntu/devops")}"

    }
 }
}
resource "null_resource" "ansible"{
  depends_on = ["aws_instance.instance","data.template_file.dev_hosts"]
  provisioner "local-exec" {
  command="ansible-playbook apache.yml"
 }
}
