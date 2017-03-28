defmodule JokesTest do
  use ExUnit.Case
  doctest Jokes
  import Jokes
  test "test with help" do
    assert main(["--help"])
    assert main(["-h"])
  end
end
