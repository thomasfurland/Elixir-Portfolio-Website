defmodule GithubDriver.Tentacat do
  alias Tentacat
  alias GithubDriver.Result

  @behaviour GithubDriver.Driver

  @api_key Application.get_env(:github_driver, __MODULE__)[:token]

  @impl true
  def name() do
    "Tentacat"
  end

  @impl true
  def request(api_key \\ @api_key, _opts \\ []) do
    client = Tentacat.Client.new(%{access_token: api_key})
    with {200, _user, _} <- Tentacat.Users.me(client)
    do
      make_request(client)
    else
      _err -> %Result{status: :auth_error}
    end
  end

  defp make_request(client) do
    with {200, repos, _} <- Tentacat.Repositories.list_mine(client, [type: "public", type: "owner"])
    do
      %Result{response: repos, status: :ok}
    else
      _err -> %Result{status: :error}
    end
  end

end
