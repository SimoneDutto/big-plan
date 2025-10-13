output "name" {
  description = "The name of the Juju application."
  value       = juju_application.postgresql.name
}

output "database_offer" {
  description = "The url of the database offer."
  value       = juju_offer.database.url
}
