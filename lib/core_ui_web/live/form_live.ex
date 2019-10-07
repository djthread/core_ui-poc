defmodule CoreUIWeb.FormLive do
  use Phoenix.LiveView
  alias CoreUIWeb.FormView

  def render(assigns) do
    FormView.render("index.html", assigns)
  end

  def mount(%{form_json: form_json}, socket) do
    IO.inspect(form_json)
    {:ok, socket}
  end
end
