defmodule Still.Snowpack do
  def build do
    GenServer.call(Still.Snowpack.Process, :build, :infinity)
  end
end
