defmodule CoreUIWeb.FormController do
  use CoreUIWeb, :controller

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
    render(conn, "index.html")
  end

  defp launch(_, _) do
    {:error, :not_found}
  end
end
