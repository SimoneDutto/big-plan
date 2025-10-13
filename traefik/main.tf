resource "juju_model" "traefik" {
  name = var.model
}

resource "juju_application" "traefik" {
  model = juju_model.traefik.name
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
}

resource "juju_offer" "ingress" {
  depends_on = [juju_application.traefik]

  model            = juju_model.traefik.name
  application_name = juju_application.traefik.name
  name             = "${juju_application.traefik.name}-ingress"
  endpoints        = ["ingress"]
}
