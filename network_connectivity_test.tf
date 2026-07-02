variable "connectivity_test_host" {
  description = "Host or IP to test from the HCP Terraform agent."
  type        = string
}

variable "connectivity_test_port" {
  description = "TCP port to test from the HCP Terraform agent."
  type        = string
}

resource "null_resource" "tcp_connectivity_test" {
  triggers = {
    host       = var.connectivity_test_host
    port       = var.connectivity_test_port
    always_run = timestamp()
  }

  provisioner "local-exec" {
    interpreter = ["/bin/sh", "-c"]
    command     = <<-EOT
    cat /etc/hostname 2>/dev/null || hostname || uname -n
    nc -vz ${var.connectivity_test_host} ${var.connectivity_test_port} 2>&1 | tee ${path.module}/.connectivity_test_result.txt || true
  EOT
    #command     = "nc -vz ${var.connectivity_test_host} ${var.connectivity_test_port} 2>&1 | tee ${path.module}/.connectivity_test_result.txt || true"
  }
}

output "connectivity_test_target" {
  description = "Connectivity target tested from the HCP Terraform agent."
  value       = "${var.connectivity_test_host}:${var.connectivity_test_port}"
}

output "connectivity_test_result" {
  description = "Raw output from the nc connectivity test command."
  value       = try(file("${path.module}/.connectivity_test_result.txt"), "")
}
