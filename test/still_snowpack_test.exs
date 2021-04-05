defmodule Still.SnowpackTest do
  use ExUnit.Case
  doctest Still.Snowpack

  test "greets the world" do
    assert Still.Snowpack.hello() == :world
  end
end
