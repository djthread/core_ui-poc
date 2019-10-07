defmodule CoreUIWeb.FallbackController do
  use CoreUIWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(CoreUIWeb.ErrorView)
    |> render(:"404")
  end
end
