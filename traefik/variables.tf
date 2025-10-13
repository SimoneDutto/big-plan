variable "model" {
  description = "The name of the Juju model."
  type        = string
  default     = "traefik-model"
}

variable "name" {
  description = "The name of the Juju application."
  type        = string
  default     = "ingress"
}

variable "units" {
  description = "The desired Juju unit count to deploy."
  type        = number
  default     = 1

  validation {
    condition     = var.units > 0
    error_message = "The unit count must be a positive integer."
  }
}

variable "trust" {
  description = "The status to grant the Juju application full access to the cluster."
  type        = bool
  default     = true
}

variable "charm" {
  description = "The application charm operator information."
  type = object({
    name : string
    channel : string
    base : string
  })
  default = {
    name    = "traefik-k8s"
    channel = "latest/edge"
    base    = "ubuntu@20.04"
  }
}

variable "external_hostname" {
  description = "The DNS name to be used by Traefik ingress."
  type        = string
  default     = ""
}

variable "routing_mode" {
  description = "The routing mode used by Traefik ingress."
  type        = string
  default     = "path"
}
