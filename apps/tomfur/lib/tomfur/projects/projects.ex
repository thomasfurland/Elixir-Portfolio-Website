defmodule Tomfur.Projects do
  @moduledoc """
  A Module for Handling Projects.
  Projects are listed off of github, and Elixir based projects can have a demo.
  """
  alias Timex
  alias GithubDriver
  alias Tomfur.Projects.Project

  @spec get_projects :: list(Project.t())
  def get_projects() do
    GithubDriver.fetch_repositories()
    |> process_projects()
  end

  @spec process_projects(list()) :: list(Project.t())
  def process_projects(raw) do
    raw
    |> Enum.filter(fn(p) -> Enum.member?(p["topics"], "portfolio") end)
    |> Enum.map(fn(p) -> make_project(p) end)
    |> Enum.sort(&(compare_project_demo_and_dates(&1, &2)))
  end

  @spec compare_project_demo_and_dates(Project.t(), Project.t()) :: boolean()
  def compare_project_demo_and_dates(p1, p2) do
    cond do
      p1.demo == p2.demo ->
        case DateTime.compare(p1.date, p2.date) do
          :gt ->
            true
          :lt ->
            false
          :eq ->
            false
        end
      true ->
        p1.demo
    end
  end

  defp make_project(map = %{
    "id" => id, "full_name" => name, "svn_url" => url,
    "description" => desc, "homepage" => homepage,"updated_at" => date}) do

    has_demo = Enum.member?(map["topics"], "demo")
    formatted_name = format_name(name)
    parsed_date = Timex.parse!(date, "{ISO:Extended:Z}")
    %Project{
      id: id,
      name: formatted_name,
      url: url,
      demo: has_demo,
      description: desc,
      homepage: homepage,
      date: parsed_date
    }
  end

  defp format_name(name) do
    name
    |> String.split("/")
    |> Enum.at(1) #take only repo name and throw away username
    |> String.replace(["-", "_"], " ")
    |> String.split(" ")
    |> Enum.map(&(String.capitalize(&1)))
    |> Enum.join(" ")
  end

end
