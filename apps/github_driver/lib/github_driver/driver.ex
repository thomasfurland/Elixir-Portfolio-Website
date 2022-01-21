defmodule GithubDriver.Driver do
  @callback name() :: String.t()
  @callback request(api_key :: String.t(), opt :: Keyword.t()) :: GithubDriver.Result.t()
end
