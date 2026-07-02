resource "null_resource" "windows_domain_join" {
  triggers = {
    target_host = var.target_host
    domain_name = var.domain_name
    ou_path     = coalesce(var.domain_ou_path, "")
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
      "$joinPassword = ConvertTo-SecureString '${var.domain_join_password}' -AsPlainText -Force",
      "$joinCred = New-Object System.Management.Automation.PSCredential('${var.domain_join_user}', $joinPassword)",
      "if ('${coalesce(var.domain_ou_path, "")}' -eq '') { Add-Computer -DomainName '${var.domain_name}' -Credential $joinCred -Force -ErrorAction Stop } else { Add-Computer -DomainName '${var.domain_name}' -Credential $joinCred -OUPath '${coalesce(var.domain_ou_path, "")}' -Force -ErrorAction Stop }",
      "Write-Output 'Domain join command completed. Reboot is required.'"
    ]
  }
}

output "joined_host" {
  description = "Windows host targeted for domain join."
  value       = var.target_host
}
