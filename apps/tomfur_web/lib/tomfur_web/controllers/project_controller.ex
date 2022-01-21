defmodule TomfurWeb.ProjectController do
  use TomfurWeb, :controller

  alias Tomfur.Projects
  alias Tomfur.Contents

  def index(conn, _params) do
    projects = Projects.get_projects()
    content = Contents.get_page_by(name: "projects")
    render(conn, "index.html", projects: projects, content: content)
  end

end
