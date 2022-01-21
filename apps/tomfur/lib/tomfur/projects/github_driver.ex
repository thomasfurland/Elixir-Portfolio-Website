defmodule Tomfur.Projects.GithubDriver do
  @moduledoc """
  A github driver that periodically polls for new projects. Requires a login account
  """
  use GenServer

  alias Tentacat

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(default) when is_binary(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, defaultUserToken(), name: __MODULE__)
  end

  @spec init(any) :: {:stop, binary()} | {:ok, Tentacat.Client.t()}
  def init(token) do
    with {:ok, client} <- authUser(token) do
      Agent.start_link(fn -> [] end, name: :agentMOD)
      updateRepoList(client)
      schedule_update()
      {:ok, client}
    else
      {:error, _} -> {:stop, "User not Authenticated"}
    end
  end

  def handle_info(:update, client) do
    updateRepoList(client)
    schedule_update()
    {:noreply, client}
  end

  def handle_cast({:login, token}, client) do
    with {:ok, new_client} <- authUser(token) do
      {:noreply, new_client}
    else
      {:error, _} -> {:noreply, client}
    end
  end

  def handle_call(:projects, _from, client) do
    projectList = Agent.get(:agentMOD, &(&1))
    {:reply, projectList, client}
  end

  defp updateRepoList(client) do
    with {200, repositories, _} <- Tentacat.Repositories.list_mine(client, [type: "public", type: "owner"]) do
      Agent.update(:agentMOD, fn _map -> repositories end)
    end
  end

  defp schedule_update() do
    hours = 60 * 60 * 1000
    Process.send_after(self(), :update, 1 * hours)
  end

  def authUser(token) do
    client = Tentacat.Client.new(%{access_token: token})
    with {200, _user, _} <- Tentacat.Users.me(client) do
      {:ok, client}
    else
      {_,_,_} -> {:error, "Authorization Failure"}
    end
  end

  def defaultUserToken() do
    config = Application.get_env(:tomfur, __MODULE__)
    config[:token]
  end

end
