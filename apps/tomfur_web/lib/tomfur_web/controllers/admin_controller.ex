defmodule TomfurWeb.AdminController do
  use TomfurWeb, :controller

  import TomfurWeb.Auth

  alias Tomfur.Admin
  alias Tomfur.Admin.User


  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do
    changeset = Admin.change_registration(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Admin.register_user(user_params) do
      {:ok, user} ->
        conn
        |> login(user)
        |> put_flash(:info, "#{user.name} registered!")
        |> redirect(to: Routes.admin_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

end
