resource "juju_model" "traefik" {
  name = var.model
}

resource "juju_application" "traefik" {
  name  = var.name
  trust = var.trust
  units = var.units

  charm {
    name    = var.charm.name
    channel = var.charm.channel
    base    = var.charm.base
  }

  config = {
    external_hostname = var.external_hostname
    routing_mode      = var.routing_mode
  }
  model_uuid = juju_model.traefik.uuid
}

resource "juju_offer" "ingress" {
  depends_on = [juju_application.traefik]

  application_name = juju_application.traefik.name
  name             = "${juju_application.traefik.name}-ingress"
  endpoints        = ["ingress"]
  model_uuid       = juju_model.traefik.uuid
}
