# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config
alias SmartEnergy.Controllers.Helpers

config :smart_energy,
  ecto_repos: [SmartEnergy.Repo]

# Configures the endpoint
config :smart_energy, SmartEnergyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4ZqteTX7Bt6dy6F9y6bUV0Fckhxb6/9G+lofF0DEeqMCtVSO6ZbqBgXjURVbiRqi",
  render_errors: [view: SmartEnergyWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: SmartEnergy.PubSub,
  live_view: [signing_salt: "1pxckN4y"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :smart_energy, SmartEnergy.Guardian,
  issuer: "smart_energy",
  secret_key: "ADxP/Ea0fC/5JoYw86mdM12Ua6/LkbytKFpulMYVCFm7AGnTXsqMosh7odko0edY"

config :canary,
  repo: SmartEnergy.Repo,
  not_found_handler: {Helpers.Authorization, :handle_not_found},
  unauthorized_handler: {Helpers.Authorization, :handle_unauthorized}

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
