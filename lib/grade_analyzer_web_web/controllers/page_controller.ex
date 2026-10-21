defmodule GradeAnalyzerWebWeb.PageController do
  use GradeAnalyzerWebWeb, :controller

  alias GradeAnalyzerWeb.Repo
  alias GradeAnalyzerWeb.Student

  def home(conn, _params) do
    students = Repo.all(Student)
    data = build_page_data(students)

    render(conn, :home, data)
  end

  def students(conn, _params) do
    students = Repo.all(Student)
    render(conn, :students, students: students)
  end

  def analytics(conn, _params) do
    students = Repo.all(Student)
    data = build_page_data(students)

    render(conn, :analytics, data)
  end

  def create_student(conn, %{"student" => params}) do
    case %Student{} |> Student.changeset(params) |> Repo.insert() do
      {:ok, _student} ->
        conn
        |> put_flash(:info, "Student added successfully!")
        |> redirect(to: "/students")

      {:error, _changeset} ->
        conn
        |> put_flash(
          :error,
          "Invalid name or marks. Enter marks from 1 to 100."
        )
        |> redirect(to: "/students")
    end
  end

  def create_student(conn, _params) do
    conn
    |> put_flash(:error, "Please enter student name and marks.")
    |> redirect(to: "/students")
  end

  def edit_student(conn, %{"id" => id}) do
    student = Repo.get!(Student, id)
    render(conn, :edit_student, student: student)
  end

  def update_student(conn, %{"id" => id, "student" => params}) do
    student = Repo.get!(Student, id)

    case student |> Student.changeset(params) |> Repo.update() do
      {:ok, _student} ->
        conn
        |> put_flash(:info, "Student updated successfully!")
        |> redirect(to: "/students")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Update failed. Check the name and marks.")
        |> redirect(to: "/students")
    end
  end

  def delete_student(conn, %{"id" => id}) do
    student = Repo.get!(Student, id)

    case Repo.delete(student) do
      {:ok, _student} ->
        conn
        |> put_flash(:info, "Student deleted successfully!")
        |> redirect(to: "/students")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Student could not be deleted.")
        |> redirect(to: "/students")
    end
  end

  # Calculate all Dashboard and Analytics values from database records.
  defp build_page_data(students) do
    total_students = length(students)

    total_marks =
      Enum.reduce(students, 0, fn student, total ->
        total + student.marks
      end)

    class_average =
      if total_students == 0 do
        0.0
      else
        Float.round(total_marks / total_students, 1)
      end

    passed = Enum.count(students, fn student -> student.marks >= 50 end)
    failed = total_students - passed

    pass_rate =
      if total_students == 0 do
        0.0
      else
        Float.round(passed * 100 / total_students, 1)
      end

    highest_student =
      Enum.max_by(students, & &1.marks, fn -> nil end)

    lowest_student =
      Enum.min_by(students, & &1.marks, fn -> nil end)

    grade_counts = %{
      a: Enum.count(students, fn s -> s.marks >= 80 end),
      b: Enum.count(students, fn s -> s.marks >= 70 and s.marks < 80 end),
      c: Enum.count(students, fn s -> s.marks >= 60 and s.marks < 70 end),
      d: Enum.count(students, fn s -> s.marks >= 50 and s.marks < 60 end),
      f: Enum.count(students, fn s -> s.marks < 50 end)
    }

    grade_percentages = %{
      a: percentage(grade_counts.a, total_students),
      b: percentage(grade_counts.b, total_students),
      c: percentage(grade_counts.c, total_students),
      d: percentage(grade_counts.d, total_students),
      f: percentage(grade_counts.f, total_students)
    }

    %{
      students: students,
      total_students: total_students,
      class_average: class_average,
      passed: passed,
      failed: failed,
      pass_rate: pass_rate,
      highest_student: highest_student,
      lowest_student: lowest_student,
      grade_counts: grade_counts,
      grade_percentages: grade_percentages
    }
  end

  defp percentage(_count, 0), do: 0.0

  defp percentage(count, total) do
    Float.round(count * 100 / total, 1)
  end
end
