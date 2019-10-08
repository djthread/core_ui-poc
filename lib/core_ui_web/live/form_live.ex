defmodule CoreUIWeb.FormLive do
  use Phoenix.LiveView
  alias CoreUI.Spec
  alias CoreUIWeb.FormView

  def render(assigns) do
    FormView.render("index.html", assigns)
  end

  def mount(%{spec: spec}, socket) do
    changeset = Spec.changeset(spec, %{}, %{})
    socket = assign(socket, spec: spec, changeset: changeset)
    {:ok, socket}
  end
end
