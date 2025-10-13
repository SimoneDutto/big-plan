terraform {
  required_version = ">= 1.6.6"
  required_providers {
    juju = {
      source  = "juju/juju"
      version = ">=1.0.0"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 1.53.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.23.0"
    }
  }
}
