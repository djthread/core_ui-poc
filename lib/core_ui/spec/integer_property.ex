defmodule CoreUI.Spec.IntegerProperty do
  @moduledoc "An integer property"
  alias Ecto.Changeset
  alias Phoenix.HTML.Form

  defstruct minimum: nil, maximum: nil

  def ecto_type, do: :integer

  def build_property(prop) do
    %__MODULE__{minimum: prop["minimum"], maximum: prop["maximum"]}
  end

  def build_input(form, key, _prop) do
    Form.text_input(form, key)
  end

  def build_validation(changeset, key, %{minimum: min, maximum: max}) do
    opts =
      []
      |> (fn o -> if min, do: o ++ [greater_than_or_equal_to: min], else: o end).()
      |> (fn o -> if max, do: o ++ [less_than_or_equal_to: max], else: o end).()

    Changeset.validate_number(changeset, key, opts)
  end
end
