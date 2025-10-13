output "name" {
  description = "The name of the Juju application."
  value       = juju_application.openfga.name
}

output "openfga_offer" {
  description = "The url of the openfga offer."
  value       = juju_offer.openfga.url
}
