defmodule GradeAnalyzerWeb.Student do
  use Ecto.Schema
  import Ecto.Changeset

  schema "students" do
    field :name, :string
    field :marks, :integer

    timestamps(type: :utc_datetime)
  end

  def changeset(student, attrs) do
    student
    |> cast(attrs, [:name, :marks])
    |> validate_required([:name, :marks])
    |> validate_length(:name, min: 1)
    |> validate_number(:marks,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 100
    )
  end
end
