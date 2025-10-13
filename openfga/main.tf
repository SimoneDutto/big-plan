resource "juju_application" "openfga" {
  model = var.model
  name  = var.name
  trust = var.trust
  units = var.units

  charm {
    name    = var.charm.name
    channel = var.charm.channel
    base    = var.charm.base
  }
}

resource "juju_offer" "openfga" {
  depends_on = [juju_application.openfga]

  model            = var.model
  application_name = juju_application.openfga.name
  endpoints        = ["openfga"]
}

resource "juju_integration" "db_integration" {
  model = var.model
  application {
    offer_url = var.database_offer_url
  }

  application {
    name     = juju_application.openfga.name
    endpoint = "database"
  }
}

