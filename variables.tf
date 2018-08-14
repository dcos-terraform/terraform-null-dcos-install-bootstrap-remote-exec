variable "master_ips" {
  type        = "list"
  description = "list of master private ips"
}

variable "bootstrap_ip" {
  description = "the bootstrap ip to ssh to"
}

variable "os_user" {
  default     = "centos"
  description = "The OS user to be used with ssh exec"
}

variable "depends_on" {
  default     = []
  description = "modules are missing the depends_on feature. Faking this feature with input and output variables"
}
