defmodule PhoenixSlime do
  @doc """
  Provides the `~l` sigil with HTML safe Slime syntax inside source files.

  Raises on attempts to use `\#{}`. Use `~L` to allow templating with `\#{}`.

      iex> import PhoenixSlime
      iex> assigns = %{w: "world"}
      iex> ~l"\""
      ...> p = "hello " <> @w
      ...> "\""
      {:safe, ["<p>", "hello world", "</p>"]}
  """
  defmacro sigil_l(expr, opts) do
    handle_sigil(expr, opts, __CALLER__.line)
  end

  @doc """
  Provides the `~L` sigil for compiling Slime markup into `eex` or `heex` template code.

      iex> import PhoenixSlime
      iex> ~L"\""
      ...> p hello \#{"world"}
      ...> "\""
      {:safe, ["<p>hello ", "world", "</p>"]}
  """
  defmacro sigil_L(expr, opts) do
    handle_sigil(expr, opts, __CALLER__.line)
  end

  defp handle_sigil({:<<>>, _, [expr]}, [], line) do
    expr
    |> Slime.Renderer.precompile()
    |> EEx.compile_string(engine: Phoenix.HTML.Engine, line: line + 1)
  end

  defp handle_sigil(_, _, _) do
    raise ArgumentError,
          ~S(Templating is not allowed with #{} in ~l sigil.) <>
            ~S( Remove the #{}, use = to insert values, or ) <>
            ~S(use ~L to template with #{}.)
  end

  defmacro sigil_h({:<<>>, meta, [expr]}, []) do
    unless Macro.Env.has_var?(__CALLER__, {:assigns, nil}) do
      raise "~H requires a variable named \"assigns\" to exist and be set to a map"
    end

    expr =
      expr
      |> Slime.Renderer.precompile_heex()

    options = [
      engine: Phoenix.LiveView.TagEngine,
      file: __CALLER__.file,
      line: __CALLER__.line + 1,
      caller: __CALLER__,
      indentation: meta[:indentation] || 0,
      source: expr,
      tag_handler: Phoenix.LiveView.HTMLEngine
    ]

    EEx.compile_string(expr, options)
  end
end
