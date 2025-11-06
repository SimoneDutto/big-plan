resource "juju_application" "openfga" {
  name  = var.name
  trust = var.trust
  units = var.units

  charm {
    name    = var.charm.name
    channel = var.charm.channel
    base    = var.charm.base
  }
  model_uuid = var.model
}

resource "juju_offer" "openfga" {
  depends_on = [juju_application.openfga]

  application_name = juju_application.openfga.name
  endpoints        = ["openfga"]
  model_uuid       = var.model
}

resource "juju_integration" "db_integration" {
  application {
    offer_url = var.database_offer_url
  }

  application {
    name     = juju_application.openfga.name
    endpoint = "database"
  }
  model_uuid = var.model
}

