defmodule GradeAnalyzerWebWeb.Router do
  use GradeAnalyzerWebWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GradeAnalyzerWebWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GradeAnalyzerWebWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/students", PageController, :students
    post "/students", PageController, :create_student

    get "/students/:id/edit", PageController, :edit_student
    post "/students/:id/update", PageController, :update_student
    post "/students/:id/delete", PageController, :delete_student

    get "/analytics", PageController, :analytics
  end

  if Application.compile_env(:grade_analyzer_web, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: GradeAnalyzerWebWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
