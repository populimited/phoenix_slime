defmodule PhoenixSlimeLeexTest do
  use ExUnit.Case
  alias Phoenix.View
  doctest PhoenixSlime


  defmodule MyApp.PageView do
    use Phoenix.View, root: "test/fixtures/templates"
  end

  test "render a leex template" do
    result = View.render(MyApp.PageView, "new_leex.html", [])
    assert result.__struct__ == Phoenix.LiveView.Rendered
    assert result.static == ["<h2 name=\"value\">inner html</h2>"]
  end
end
