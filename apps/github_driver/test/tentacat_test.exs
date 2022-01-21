defmodule GithubDriver.TentacatTest do
  use ExUnit.Case, async: true

  alias GithubDriver.Tentacat
  alias GithubDriver.Result

  test "test name function gets correct name" do
    assert Tentacat.name() == "Tentacat"
  end

  test "test request function gets valid response with valid API key" do
    assert %Result{status: :ok} = Tentacat.request()
  end

  test "test request gets auth error response with invalid api key" do
    assert %Result{status: :auth_error} = Tentacat.request("invalid key")
  end

end
