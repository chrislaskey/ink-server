defmodule InkServerTest do
  use ExUnit.Case
  doctest InkServer

  test "greets the world" do
    assert InkServer.hello() == :world
  end
end
