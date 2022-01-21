defmodule TomfurWeb.PageViewTest do
  use TomfurWeb.ConnCase, async: true
  import Phoenix.View

  alias Tomfur.Projects.Project
  alias Tomfur.Contents.Page

  alias TomfurWeb.ProjectView

  @content %Page{
    name: "Projects",
    header: "Test Header",
    main: "Test Main"
  }

  @projects [
    %Project{name: "Proj1", description: "Test Description1", url: "www.test1.com", homepage: "test Homepage1", demo: true},
    %Project{name: "Proj2", description: "Test Description2", url: "www.test2.com", homepage: "test Homepage2", demo: true},
    %Project{name: "Proj3", description: "Test Description3", url: "www.test3.com", homepage: "test Homepage3", demo: false}
  ]

  test "render index.html", %{conn: conn} do
    content = render_to_string(ProjectView, "index.html", conn: conn, content: @content, projects: @projects)
    assert String.contains?(content, @content.header)
    assert String.contains?(content, @content.main)

    for project <- @projects do
      assert String.contains?(content, project.name)
      assert String.contains?(content, project.description)
      assert String.contains?(content, project.url)
      assert String.contains?(content, project.homepage)
    end


  end

end
