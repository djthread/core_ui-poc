defmodule CoreUIWeb.FormController do
  use CoreUIWeb, :controller
  import Phoenix.LiveView.Controller

  action_fallback(CoreUIWeb.FallbackController)

  def index(conn, %{"form" => form}) do
    with {:ok, json} <-
           ~w(#{File.cwd!()} test fixtures forms #{form}.json)
           |> Path.join()
           |> File.read() do
      Jason.decode(json)
    end
    |> launch(conn)
  end

  defp launch({:ok, json}, conn) do
    live_render(conn, CoreUIWeb.FormLive, session: %{
      form_json: json
    })
  end

  defp launch(_, _) do
    {:error, :not_found}
  end
end
