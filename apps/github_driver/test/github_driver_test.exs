defmodule GithubDriverTest do
  use ExUnit.Case, async: true
  alias GithubDriver.Cache
  alias GithubDriver.Result
  doctest GithubDriver

  defmodule TestDriver do
    def request() do
      %Result{status: :ok, response: ["Response"]}
    end
  end

  defmodule TestFailDriver do
    def request() do
      %Result{status: :auth_error}
    end
  end

  setup %{test: name} do
    {:ok, pid} = Cache.start_link(name: name)
    {:ok, name: name, pid: pid}
  end

  test "can fetch repositories", %{name: name} do
    GithubDriver.fetch_repositories(driver: TestDriver, cache: name)
    assert {:ok, _} = Cache.fetch(name, :last_request)
    list = GithubDriver.fetch_repositories(driver: TestDriver, cache: name)
    {:ok, cache_list} = Cache.fetch(name, :data)
    assert list == cache_list
  end

  test "cache still accessible even if fetching not possible", %{name: name} do
    list = GithubDriver.fetch_repositories(driver: TestDriver, cache: name)
    assert {:ok, time1} = Cache.fetch(name, :last_request)
    list2 = GithubDriver.fetch_repositories(driver: TestFailDriver, cache: name)

    assert list == Cache.fetch_data(name)
    assert list == list2
    refute time1 == Cache.fetch(name, :last_request)
  end

  test "fetches empty list if error occurs immediately", %{name: name}  do
    list = GithubDriver.fetch_repositories(driver: TestFailDriver, cache: name)
    assert list == []
  end

end
