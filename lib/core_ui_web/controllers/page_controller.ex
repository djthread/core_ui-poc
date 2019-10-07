defmodule CoreUIWeb.PageController do
  use CoreUIWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
