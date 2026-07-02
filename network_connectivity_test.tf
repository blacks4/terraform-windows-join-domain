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
      output_file="${path.module}/.connectivity_test_result.txt"
      rm -f "$output_file"
      output="$(nc -vz ${var.connectivity_test_host} ${var.connectivity_test_port} 2>&1)"
      exit_code=$?
      printf "%s\n" "$output" | tee "$output_file"
      exit "$exit_code"
    EOT
  }
}

output "connectivity_test_target" {
  description = "Connectivity target tested from the HCP Terraform agent."
  value       = "${var.connectivity_test_host}:${var.connectivity_test_port}"
}

output "connectivity_test_result" {
  description = "Raw output from the nc connectivity test command."
  value       = try(trimspace(file("${path.module}/.connectivity_test_result.txt")), "No connectivity test result file found yet.")
}
