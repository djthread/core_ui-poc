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

  @spec from_json_schema(map()) :: {:ok, t} | {:error, String.t()}
  def from_json_schema(
        %{"type" => "object", "properties" => properties} = schema
      ) do
    spec = %__MODULE__{required: Map.get(schema, "required", [])}

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

  @spec add_prop(t, String.t(), map()) :: {:ok, t} | {:error, String.t()}
  defp add_prop(spec, key, %{"type" => type} = prop)
       when type in @valid_types do
    mod =
      "#{__MODULE__}.#{String.capitalize(type)}Property"
      |> String.to_existing_atom()

    if function_exported?(mod, :build_property, 1) do
      property = apply(mod, :build_property, [prop])
      %{spec | properties: Map.put(spec.properties, key, property)}
    else
      {:error, "Unrecognized type: #{type}"}
    end
  end
end
