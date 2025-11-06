data "juju_model" "model" {
  name  = var.model
  owner = "admin"
}


resource "juju_application" "postgresql" {
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
  model_uuid = data.juju_model.model.uuid
}

resource "juju_offer" "database" {
  depends_on = [juju_application.postgresql]

  application_name = juju_application.postgresql.name
  endpoints        = ["database"]
  model_uuid       = data.juju_model.model.uuid
}
