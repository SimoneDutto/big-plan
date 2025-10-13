terraform {
  required_providers {
    juju = {
      source = "juju/juju"
      # version = ">=1.0.0"
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
  model              = juju_model.openfga_model.name
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
  name  = "temporal"
  model = resource.juju_model.prod.name

  charm {
    name = "temporal-k8s"
  }

  config = {
    num-history-shards = 2
  }
}


resource "juju_integration" "temporal_db" {
  model = resource.juju_model.prod.name
  application {
    offer_url = module.postgres.database_offer
  }

  application {
    name     = juju_application.temporal_k8s.name
    endpoint = "db"
  }
}

resource "juju_integration" "temporal_visibility_db" {
  model = resource.juju_model.prod.name
  application {
    offer_url = module.postgres.database_offer
  }

  application {
    name     = juju_application.temporal_k8s.name
    endpoint = "visibility"
  }
}

resource "juju_application" "temporal_admin_k8s" {
  name  = "temporal-admin"
  model = juju_model.prod.name

  charm {
    name = "temporal-admin-k8s"
  }
}

resource "juju_integration" "temporal_admin" {
  model = juju_model.prod.name

  application {
    name     = juju_application.temporal_k8s.name
    endpoint = "admin"
  }

  application {
    name     = juju_application.temporal_admin_k8s.name
    endpoint = "admin"
  }
}


resource "juju_application" "temporal_k8s_ui" {
  name  = "temporalui"
  model = resource.juju_model.prod.name

  charm {
    name = "temporal-ui-k8s"
  }
}

resource "juju_integration" "temporal_ui" {
  model = juju_model.prod.name

  application {
    name     = juju_application.temporal_k8s.name
    endpoint = "ui"
  }

  application {
    name     = juju_application.temporal_k8s_ui.name
    endpoint = "ui"
  }
}


