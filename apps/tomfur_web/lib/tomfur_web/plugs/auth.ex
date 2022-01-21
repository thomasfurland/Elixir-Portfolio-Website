defmodule TomfurWeb.Auth do
  import Plug.Conn
  import Tomfur.Admin

  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    cond do
      conn.assigns[:current_user] ->
        conn
      user = user_id && get_user(user_id) ->
        assign(conn, :current_user, user)
      true ->
        assign(conn, :current_user, nil)
    end
  end

  @spec login(Plug.Conn.t(), Tomfur.Admin.User) :: Plug.Conn.t()
  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

end
