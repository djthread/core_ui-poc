defmodule CoreUIWeb.FormController do
  use CoreUIWeb, :controller

  def index(conn, %{"form" => form}) do
    form |> File.read() |> launch(conn)
  end

  defp launch({:ok, json}, conn) do
    IO.inspect(params)
    render(conn, "index.html")
  end
end
