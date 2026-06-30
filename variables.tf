variable "target_host" {
  description = "Target Windows server IP or hostname for WinRM."
  type        = string
}

variable "winrm_port" {
  description = "WinRM HTTP port."
  type        = number
  default     = 5985
}

variable "winrm_username" {
  description = "Local admin (or equivalent) account used for WinRM login."
  type        = string
}

variable "winrm_password" {
  description = "Password for winrm_username."
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "Active Directory domain FQDN, for example corp.example.com."
  type        = string
}

variable "domain_ou_path" {
  description = "Optional AD OU path, for example OU=Servers,DC=corp,DC=example,DC=com."
  type        = string
  default     = null
}

variable "domain_join_user" {
  description = "Domain user with permission to join computers, for example CORP\\svc_domain_join."
  type        = string
}

variable "domain_join_password" {
  description = "Password for domain_join_user."
  type        = string
  sensitive   = true
}
