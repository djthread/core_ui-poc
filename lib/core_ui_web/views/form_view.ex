defmodule CoreUIWeb.FormView do
  use CoreUIWeb, :view

  def display_name(str) do
    str
    |> to_string()
    |> String.split("_")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  def build_input(form, key, prop) do
    prop.__struct__ build_input(form, key, prop)
  end
end
