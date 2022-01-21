defmodule GithubDriverTest do
  use ExUnit.Case
  alias GithubDriver.Cache
  doctest GithubDriver

  test "can fetch repositories" do
    GithubDriver.fetch_repositories(cache_expiry: 5)
    time = Cache.fetch(Cache, :last_request)
    list = GithubDriver.fetch_repositories(cache_expiry: 5)
    IO.inspect(list)
    IO.inspect(time)
  end

end
