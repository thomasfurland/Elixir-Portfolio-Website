defmodule TomfurWeb.SessionController do
  use TomfurWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    case Tomfur.Admin.authenticate_by_username_and_pass(username, password) do
      {:ok, user} ->
        conn
        |> TomfurWeb.Auth.login(user)
        |> put_flash(:info, "Welcome Back!")
        |> redirect(to: Routes.admin_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> TomfurWeb.Auth.logout()
    |> redirect(to: Routes.project_path(conn, :index))
  end

end
