defmodule GradeAnalyzerWeb.Repo do
  use Ecto.Repo,
    otp_app: :grade_analyzer_web,
    adapter: Ecto.Adapters.Postgres
end
