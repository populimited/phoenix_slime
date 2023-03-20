use Mix.Config

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine,
  sheex: PhoenixSlime.LiveView.HTMLEngine

config :phoenix, :json_library, Jason
