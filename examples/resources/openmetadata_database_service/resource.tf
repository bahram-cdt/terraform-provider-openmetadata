resource "openmetadata_database_service" "postgres" {
  name         = "ProductionPostgres"
  service_type = "Postgres"
  display_name = "Production PostgreSQL"
  description  = "Main production PostgreSQL database."

  connection_json = jsonencode({
    config = {
      type             = "Postgres"
      scheme           = "postgresql+psycopg2"
      username         = "readonly_user"
      hostPort         = "db.example.com:5432"
      database         = "production"
      sslMode          = "verify-full"
    }
  })
}
