defmodule CoreUIWeb.FormLive do
  @moduledoc false
  use Phoenix.LiveView
  alias CoreUI.Spec
  alias CoreUIWeb.FormView
  alias Ecto.Changeset

  def render(assigns) do
    FormView.render("index.html", assigns)
  end

  def mount(%{spec: spec}, socket) do
    changeset = Spec.changeset(spec, %{}, %{})
    socket = assign(socket, spec: spec, changeset: changeset)
    {:ok, socket}
  end

  def handle_event("validate", %{"form" => params}, socket) do
    changeset =
      socket.assigns.spec
      |> Spec.changeset(%{}, params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"form" => params}, socket) do
    :timer.sleep(1_000)

    status =
      case Spec.changeset(socket.assigns.spec, %{}, params) do
        %{valid?: true} = cs ->
          {:ok, Changeset.apply_changes(cs)}

        cs ->
          :error
      end

      {:noreply, assign(socket, status: status)}
  end
end
