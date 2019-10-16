defmodule CoreUIWeb.FormController do
  use CoreUIWeb, :controller
  import Phoenix.LiveView.Controller
  alias CoreUI.Spec
  require Logger

  action_fallback(CoreUIWeb.FallbackController)

  def redirect_to_login(conn, _) do
    redirect(conn, to: "/login")
  end

  def index(conn, %{"form" => form}) do
    with {:ok, json} <-
           ~w(#{File.cwd!()} test fixtures forms #{form}.json)
           |> Path.join()
           |> File.read(),
         {:ok, json} <- Jason.decode(json),
         {:ok, spec} <- Spec.from_json_schema(json) do
      launch(conn, spec)
    else
      bad ->
        Logger.error(inspect(bad))
        {:error, :not_found}
    end
  end

  defp launch(conn, spec) do
    live_render(conn, CoreUIWeb.FormLive,
      session: %{
        spec: spec
      }
    )
  end
end
