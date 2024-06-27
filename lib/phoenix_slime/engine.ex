defmodule PhoenixSlime.Engine do
  @behaviour Phoenix.Template.Engine

  @doc """
  Precompiles the String file_path into a function definition
  """
  def compile(path, _name) do
    path
    |> read!()
    |> EEx.compile_string(engine: Phoenix.HTML.Engine, file: path, line: 1)
  end

  defp read!(file_path) do
    file_path
    |> File.read!()
    |> precompile(file_path)
  end

  defp precompile(file, path) do
    if is_sheex?(path),
      do: Slime.Renderer.precompile_heex(file),
      else: Slime.Renderer.precompile(file)
  end

  defp is_sheex?(path),
    do: String.ends_with?(path, ".sheex")
end
