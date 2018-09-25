variable "master_ips" {
  type        = "list"
  description = "List of masterips to SSH to"
}

variable "bootstrap_ip" {
  description = "The bootstrap IP to SSH to"
}

variable "os_user" {
  default     = "centos"
  description = "The OS user to be used"
}

variable "trigger" {
  default     = []
  description = "Triggers for null resource"
}

variable "depends_on" {
  default     = []
  description = "Modules are missing the depends_on feature. Faking this feature with input and output variables"
}
