use Mix.Config

# Configure your database
config :core_ui, CoreUI.Repo,
  username: "postgres",
  password: "postgres",
  database: "core_ui_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :core_ui, CoreUIWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
