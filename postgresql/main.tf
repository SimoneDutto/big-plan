data "juju_model" "model" {
  name = var.model
}


resource "juju_application" "postgresql" {
  model = data.juju_model.model.name
  name  = var.name
  trust = var.trust
  units = var.units

  charm {
    name    = var.charm.name
    channel = var.charm.channel
    base    = var.charm.base
  }

  config = {
    plugin_pg_trgm_enable   = true
    plugin_uuid_ossp_enable = true
    plugin_btree_gin_enable = true
  }
}

resource "juju_offer" "database" {
  depends_on = [juju_application.postgresql]

  model            = data.juju_model.model.name
  application_name = juju_application.postgresql.name
  endpoints        = ["database"]
}
