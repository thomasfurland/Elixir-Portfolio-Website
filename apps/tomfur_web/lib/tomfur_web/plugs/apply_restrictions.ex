defmodule TomfurWeb.ApplyRestrictions do
  import Phoenix.Controller
  import Plug.Conn
  alias TomfurWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Routes.project_path(conn, :index))
      |> halt()
    end
  end
end
