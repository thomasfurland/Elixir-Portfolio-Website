defmodule GithubDriver do
  @moduledoc """
  Documentation for `GithubDriver`.
  """
  alias GithubDriver.Cache

  @cache GithubDriver.Cache
  @driver GithubDriver.Tentacat
  @cache_expiry 5

  defmodule Result do
    @type t :: %__MODULE__{
      response: %{} | nil,
      status: :ok | :error | :auth_error
    }
    defstruct [:response, :status]
  end

  def fetch_repositories(opts \\ []) do
    driver = opts[:driver] || @driver
    cache_expiry = opts[:cache_expiry] || @cache_expiry
    cache_name = opts[:cache] || @cache

    case Cache.fetch(cache_name, :last_request) do
      {:ok, result}  ->
        unless time_elapsed(cache_expiry, result) do
          Cache.fetch_data(cache_name)
        else
          request_and_cache(driver, cache_name)
        end
      :error ->
        request_and_cache(driver, cache_name)
    end

  end

  defp time_elapsed(time_limit_minutes, date) do
    time_diff = DateTime.diff(DateTime.utc_now(), date)
    time_limit_seconds = time_limit_minutes * 60
    time_limit_seconds < time_diff
  end

  defp request_and_cache(driver, cache) do
    with %Result{status: :ok, response: response} <- driver.request()
    do
      Cache.put(cache, :last_request, DateTime.utc_now())
      Cache.put(cache, :data, response)
      response
    else
      _ ->
        Cache.put(cache, :last_request, DateTime.utc_now())
        Cache.fetch_data(cache)
    end
  end


end
