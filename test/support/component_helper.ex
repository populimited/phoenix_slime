defmodule ComponentHelper do
  def render_to_string(component) do
    component
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.iodata_to_binary()
  end
end
