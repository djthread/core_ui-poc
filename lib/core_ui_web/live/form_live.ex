defmodule CoreUIWeb.FormLive do
  use Phoenix.LiveView
  alias CoreUIWeb.FormView

  def render(assigns) do
    FormView.render("index.html", assigns)
  end

  def mount(%{spec: spec}, socket) do
    {:ok, socket}
  end
end
