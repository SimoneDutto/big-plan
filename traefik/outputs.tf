output "name" {
  description = "The name of the Juju application."
  value       = juju_application.traefik.name
}

output "ingress_offer" {
  description = "The url of the ingress offer."
  value       = juju_offer.ingress.url
}

