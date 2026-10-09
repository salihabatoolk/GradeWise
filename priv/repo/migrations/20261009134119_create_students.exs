defmodule GradeAnalyzerWeb.Repo.Migrations.CreateStudents do
  use Ecto.Migration

  def change do
    create table(:students) do
      add :name, :string
      add :marks, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
