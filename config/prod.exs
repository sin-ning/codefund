use Mix.Config

config :code_sponsor, CodeSponsorWeb.Endpoint,
  load_from_system_env: true,
  url: [scheme: "http", host: "code-sponsor-phx.herokuapp.com"],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")

# Do not print debug messages in production
config :logger, level: :info

# Configure your database
config :code_sponsor, CodeSponsor.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true