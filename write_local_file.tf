resource "null_resource" "create_remote_file" {
	triggers = {
		target_host = var.target_host
		file_path   = "C:/created_by_terraform.txt"
		content     = "This file was created by Terraform."
	}

	connection {
		type     = "winrm"
		host     = var.target_host
		port     = var.winrm_port
		user     = var.winrm_username
		password = var.winrm_password
		https    = false
		insecure = true
		use_ntlm = true
		timeout  = "10m"
	}

	provisioner "remote-exec" {
		inline = [
			"$ErrorActionPreference = 'Stop'",
			"$path = 'C:/created_by_terraform.txt'",
			"$content = 'This file was created by Terraform.'",
			"Set-Content -Path $path -Value $content -Encoding UTF8 -Force",
			"Write-Output \"Created file at $path\""
		]
	}
}
