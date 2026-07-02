resource "local_file" "created_by_terraform" {
	filename = "C:/created_by_terraform.txt"
	content  = "This file was created by Terraform."
}
