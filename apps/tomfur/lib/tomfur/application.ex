defmodule Tomfur.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Tomfur.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Tomfur.PubSub},
      # Start a worker by calling: Tomfur.Worker.start_link(arg)
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Tomfur.Supervisor)
  end
end
