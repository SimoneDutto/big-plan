terraform {
  required_providers {
    juju = {
      source  = "juju/juju"
    }
  }
}

variable "model_name_created_externally" {
  description = "Set to true if the Juju model is created outside of this configuration."
  type        = string
  default     = "model1"
}

provider "juju" {}

# model is a data source created outside of terraform.
module "postgres" {
  model  = var.model_name_created_externally
  source = "./postgresql"
}

resource "juju_model" "openfga_model" {
  name = "openfga-model"
}

# model is a data source, but the model is created inside the module.
module "openfga" {
  model              = juju_model.openfga_model.uuid
  source             = "./openfga"
  database_offer_url = module.postgres.database_offer
}

# model is created with the name specified inside the module
module "traefik" {
  source = "./traefik"
  model  = "traefik-model"
}

# model created top-level
resource "juju_model" "prod" {
  name = "prod"
}



# application and integration top-level
resource "juju_application" "temporal_k8s" {
  name = "temporal"

  charm {
    name = "temporal-k8s"
  }

  config = {
    num-history-shards = 2
  }
  model_uuid = resource.juju_model.prod.uuid
}


resource "juju_integration" "temporal_db" {
  application {
    offer_url = module.postgres.database_offer
  }

  application {
    name     = juju_application.temporal_k8s.name
    endpoint = "db"
  }
  model_uuid = resource.juju_model.prod.uuid
}

resource "juju_integration" "temporal_visibility_db" {
  application {
    offer_url = module.postgres.database_offer
  }

  application {
    name     = juju_application.temporal_k8s.name
    endpoint = "visibility"
  }
  model_uuid = resource.juju_model.prod.uuid
}

resource "juju_application" "temporal_admin_k8s" {
  name = "temporal-admin"

  charm {
    name = "temporal-admin-k8s"
  }
  model_uuid = juju_model.prod.uuid
}

resource "juju_integration" "temporal_admin" {

  application {
    name     = juju_application.temporal_k8s.name
    endpoint = "admin"
  }

  application {
    name     = juju_application.temporal_admin_k8s.name
    endpoint = "admin"
  }
  model_uuid = juju_model.prod.uuid
}


resource "juju_application" "temporal_k8s_ui" {
  name = "temporalui"

  charm {
    name = "temporal-ui-k8s"
  }
  model_uuid = resource.juju_model.prod.uuid
}

resource "juju_integration" "temporal_ui" {

  application {
    name     = juju_application.temporal_k8s.name
    endpoint = "ui"
  }

  application {
    name     = juju_application.temporal_k8s_ui.name
    endpoint = "ui"
  }
  model_uuid = juju_model.prod.uuid
}


