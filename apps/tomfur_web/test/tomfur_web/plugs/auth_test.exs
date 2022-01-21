defmodule TomfurWeb.AuthTest do
  use TomfurWeb.ConnCase, async: true
  alias Tomfur.Admin
  alias TomfurWeb.Auth

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(TomfurWeb.Router, :browser)
      |> get("/")
    {:ok, %{conn: conn}}
  end

  test "login puts user in the session", %{conn: conn} do
    login_conn =
      conn
      |> Auth.login(%Admin.User{id: 123})
      |> send_resp(:ok, "")

    next_conn = get(login_conn, "/downloads")
    assert get_session(next_conn, :user_id) == 123
  end

  test "logout removes user from session", %{conn: conn} do
    logout_conn =
      conn
      |> put_session(:user_id, 123)
      |> Auth.logout()
      |> send_resp(:ok, "")

    next_conn = get(logout_conn, "/downloads")
    refute get_session(next_conn, :user_id)
  end

  test "call places admin from session into assigns", %{conn: conn} do
    admin = admin_fixture()
    conn =
      conn
      |> put_session(:user_id, admin.id)
      |> Auth.call(%{})
    assert conn.assigns.current_user.id == admin.id
  end

  test "call with empty session places nil into assigns", %{conn: conn} do
    conn = Auth.call(conn, %{})
    assert conn.assigns.current_user == nil
  end

end
