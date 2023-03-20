defmodule PhoenixSlimeHeexTest do
  use ExUnit.Case

  import ComponentHelper
  doctest PhoenixSlime

  defmodule MyApp.PageHTML do
    use Phoenix.Component
    import PhoenixSlime

    def button(assigns) do
      ~h"""
      .button =assigns.text
      """
    end

    embed_templates "fixtures/templates/my_app/page/*"
  end

  test "compiles & renders a sheex template with components" do
    html = MyApp.PageHTML.new_heex_component(%{})
    |> render_to_string()

    assert html == "<div class=\"button\">Click me</div>"
  end

  test "compiles & renders a sheex template with no dynamics" do
    html = MyApp.PageHTML.new_heex_static(%{})
    |> render_to_string()

    assert html == "<h2 name=\"value\">inner html</h2>"
  end

  test "properly escapes dynamic attributes" do
    html = MyApp.PageHTML.new_heex_attribute(%{dynamic_attribute: "success"})
    |> render_to_string()

    assert html == "<h2 name=\"success\">inner html</h2>"
  end

  test "properly escapes node bodies" do
    html = MyApp.PageHTML.new_heex_body(%{})
    |> render_to_string()

    assert html == "<h2 name=\"value\">eex expression</h2>"
  end
end
