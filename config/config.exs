# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :my_app,
  ecto_repos: [MyApp.Repo]

config :my_app, MyApp.Repo,
       username: File.read!(System.get_env("DATABASE_USERNAME_FILE")),
       password: File.read!(System.get_env("DATABASE_PASSWORD_FILE")),
       database: System.get_env("DATABASE_NAME"),
       hostname: System.get_env("DATABASE_HOST"),
       pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

# Configures the endpoint
config :my_app, MyAppWeb.Endpoint,
  http: [
    port: 4000,
  ],
  url: [
    host: System.get_env("APP_HOSTNAME"),
    port: 4000,
  ],
  secret_key_base: File.read!(System.get_env("SECRET_KEY_BASE_FILE")),
  render_errors: [view: MyAppWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: MyApp.PubSub,
  live_view: [signing_salt: System.get_env("LIVE_VIEW_SIGNING_SALT")]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
