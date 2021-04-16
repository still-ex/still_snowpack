defmodule Still.Snowpack.Utils do
  def get_input_path do
    config!(:input)
  end

  def get_output_path do
    config!(:output)
  end

  def get_relative_output_path(name) do
    get_output_path()
    |> Path.join(name)
    |> Path.relative_to(Still.Utils.get_output_path())
  end

  def port do
    config(:port, 3001)
  end

  @doc """
  Returns the value configured for `:still_snowpack` by the given key. Errors if it
  doesn't exist.
  """
  def config!(key), do: Application.fetch_env!(:still_snowpack, key)

  @doc """
  Returns the value configured for `:still_snowpack` by the given key. Returns the
  provided default if it doesn't exist.
  """
  def config(key, default), do: Application.get_env(:still_snowpack, key, default)
end
