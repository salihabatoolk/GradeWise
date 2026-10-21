defmodule GradeAnalyzerWeb.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GradeAnalyzerWebWeb.Telemetry,
      GradeAnalyzerWeb.Repo,
      {DNSCluster,
       query: Application.get_env(:grade_analyzer_web, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: GradeAnalyzerWeb.PubSub},
      # Start a worker by calling: GradeAnalyzerWeb.Worker.start_link(arg)
      # {GradeAnalyzerWeb.Worker, arg},
      # Start to serve requests, typically the last entry
      GradeAnalyzerWebWeb.Endpoint
    ]

    # See https://elixir.hexdocs.pm/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GradeAnalyzerWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GradeAnalyzerWebWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
