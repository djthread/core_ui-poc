defmodule CoreUI.Spec do
  @moduledoc """
  Handle our internal `spec` data structure for rendering and validating
  forms
  """

  @type t :: %__MODULE__{}

  @valid_types ~w(string integer)

  defstruct required: [], properties: %{}

  defmodule StringProperty do
    @moduledoc "A string property"
    defstruct []

    def ecto_type, do: :string

    def build_property(_), do: %__MODULE__{}

    def build_input(form, key, prop) do
      alias Phoenix.HTML.Form
      Form.text_input(form, key)
    end
  end

  defmodule IntegerProperty do
    @moduledoc "An integer property"
    defstruct minimum: nil, maximum: nil

    def ecto_type, do: :integer

    def build_property(prop) do
      %__MODULE__{minimum: prop["minimum"], maximum: prop["maximum"]}
    end

    def build_input(form, key, prop) do
      alias Phoenix.HTML.Form
      Form.text_input(form, key)
    end
  end

  @spec from_json_schema(map()) :: {:ok, t} | {:error, String.t()}
  def from_json_schema(%{
        "schema" => %{"type" => "object", "properties" => properties} = schema
      }) do
    spec = %__MODULE__{
      required: schema |> Map.get("required", []) |> Enum.map(&String.to_atom/1)
    }

    Enum.reduce_while(properties, {:ok, spec}, fn {key, prop}, {:ok, acc} ->
      case add_prop(acc, key, prop) do
        %{} = sp -> {:cont, {:ok, sp}}
        {:error, err} -> {:halt, {:error, err}}
      end
    end)
  end

  def from_json_schema(schema) do
    {:error, "Unrecognized JSON Schema: #{inspect(schema)}"}
  end

  def changeset(spec, initial, attrs) do
    import Ecto.Changeset

    {initial, build_ecto_types(spec)}
    |> cast(attrs, Map.keys(spec.properties))
    |> validate_required(spec.required)
    # |> unique_constraint(:name)
  end

  defp build_ecto_types(%{properties: properties}) do
    Map.new(properties, fn {key, property} ->
      {key, property.__struct__.ecto_type()}
    end)
  end

  @spec add_prop(t, String.t(), map()) :: {:ok, t} | {:error, String.t()}
  defp add_prop(spec, key, %{"type" => type} = prop)
       when type in @valid_types do
    mod =
      "#{__MODULE__}.#{String.capitalize(type)}Property"
      |> String.to_existing_atom()

    if function_exported?(mod, :build_property, 1) do
      property = apply(mod, :build_property, [prop])
      properties = Map.put(spec.properties, String.to_atom(key), property)
      %{spec | properties: properties}
    else
      {:error, "Unrecognized type: #{type}"}
    end
  end
end
