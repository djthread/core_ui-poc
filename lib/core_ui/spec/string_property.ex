defmodule CoreUI.Spec.StringProperty do
  @moduledoc "A string property"
  alias Phoenix.HTML.Form

  @behaviour CoreUI.Spec

  defstruct []

  def ecto_type, do: :string

  def build_property(_), do: %__MODULE__{}

  def build_input(form, key, _prop) do
    Form.text_input(form, key)
  end

  def build_validation(changeset, _, _), do: changeset
end
