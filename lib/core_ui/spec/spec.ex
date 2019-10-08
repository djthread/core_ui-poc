defmodule CoreUI.Spec do
  @moduledoc """
  Handle our internal `spec` data structure for
  rendering and validating forms
  """
  alias Ecto.Changeset
  alias Phoenix.{HTML, HTML.Form}

  @type t :: %__MODULE__{}
  @type key :: atom()

  @callback ecto_type :: atom()
  @callback build_property(map()) :: %{__struct__: module}
  @callback build_input(Form.t(), key, map()) :: HTML.safe()
  @callback build_validation(Changeset.t(), key, map()) :: Changeset.t()

  @valid_types ~w(string integer)

  defstruct required: [], properties: %{}

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
    cs =
      {initial, build_ecto_types(spec)}
      |> Changeset.cast(attrs, Map.keys(spec.properties))
      |> Changeset.validate_required(spec.required)

    Enum.reduce(spec.properties, cs, fn {key, prop}, acc ->
      prop.__struct__.build_validation(acc, key, prop)
    end)
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
