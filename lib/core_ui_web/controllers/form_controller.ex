defmodule CoreUIWeb.FormController do
  use CoreUIWeb, :controller
  import Phoenix.LiveView.Controller
  alias CoreUI.Spec

  action_fallback(CoreUIWeb.FallbackController)

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
