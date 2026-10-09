defmodule GradeAnalyzerWebWeb.PageController do
use GradeAnalyzerWebWeb, :controller

alias GradeAnalyzerWeb.Repo
alias GradeAnalyzerWeb.Student

def home(conn, _params) do
render(conn, :home)
end

def students(conn, _params) do
students = Repo.all(Student)
render(conn, :students, students: students)
end

def analytics(conn, _params) do
render(conn, :analytics)
end

def create_student(conn, %{"student" => params}) do
case %Student{} |> Student.changeset(params) |> Repo.insert() do
{:ok, _student} ->
conn
|> put_flash(:info, "Student added successfully!")
|> redirect(to: "/students")


  {:error, _changeset} ->
    conn
    |> put_flash(:error, "Invalid name or marks. Enter marks from 1 to 100.")
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
end
