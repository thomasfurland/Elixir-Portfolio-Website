defmodule GithubDriver.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: GithubDriver.Worker.start_link(arg)
      # {GithubDriver.Worker, arg}
      GithubDriver.Cache
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :rest_for_one, name: GithubDriver.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
