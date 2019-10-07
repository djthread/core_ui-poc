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

    def build_property(_), do: %__MODULE__{}
  end

  defmodule IntegerProperty do
    @moduledoc "An integer property"
    defstruct minimum: nil, maximum: nil

    def build_property(prop) do
      %__MODULE__{minimum: prop["minimum"], maximum: prop["maximum"]}
    end
  end

  def from_json_schema(
        %{"type" => "object", "properties" => properties} = schema
      ) do
    required = Map.get(schema, "required", [])

    Enum.reduce(properties, %__MODULE__{}, fn {key, prop}, acc ->
      build_prop(acc, key in required, key, prop)
    end)
  end

  def from_json_schema(schema) do
    raise "Unrecognized JSON Schema: #{inspect(schema)}"
  end

  defp build_prop(spec, required?, key, %{"type" => type} = prop)
       when type in @valid_types do
    mod =
      "#{__MODULE__}.#{String.capitalize(type)}Property"
      |> String.to_existing_atom()

    if function_exported?(mod, :build_property, 1) do
      property = apply(mod, :build_property, [prop])
      required = if required?, do: [key], else: []

      %{
        spec
        | required: required ++ spec.required,
          properties: Map.put(spec.properties, key, property)
      }
    else
      raise "Unrecognized type: #{type}"
    end
  end
end
