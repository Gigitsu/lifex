defmodule Lifex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    runtime_opts = [
      app: Lifex.Cli,
      interval: 100,
      shutdown: {:application, :lifex}
    ]

    # List all child processes to be supervised
    children = [
      {Ratatouille.Runtime.Supervisor, runtime: runtime_opts}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lifex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def stop(_state) do
    # Do a hard shutdown after the application has been stopped.
    #
    # Another, perhaps better, option is `System.stop/0`, but this results in a
    # rather annoying lag when quitting the terminal application.
    System.halt()
  end

  @version Mix.Project.config()[:version]

  def version, do: @version
end
