defmodule CoreUI.Repo do
  use Ecto.Repo,
    otp_app: :core_ui,
    adapter: Ecto.Adapters.Postgres
end
