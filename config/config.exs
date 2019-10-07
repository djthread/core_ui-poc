# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :core_ui,
  namespace: CoreUI,
  ecto_repos: [CoreUI.Repo]

# Configures the endpoint
config :core_ui, CoreUIWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base:
    "IsAQLkEsBifGvEpkADUcUk9x35qgq0EsXBJ2CfiNUV2jl92gR7JT68CO/6ia7h6S",
  render_errors: [view: CoreUIWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CoreUI.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "YfYFeRIJAa6cyVzHcR5PAxK8ia1raaWI"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
