defmodule TomfurWeb.SessionControllerTest do
  use TomfurWeb.ConnCase, async: true

  @create_attrs %{
    "username" => "",
    "password" => ""
  }
  @invalid_attrs %{
    "username" => "noUser",
    "password" => "noPass"
  }

  test "displays Admin Backend Correctly", %{conn: conn} do
    conn = get(conn, Routes.session_path(conn, :new))
    assert html_response(conn, 200) =~ "Admin Login Portal"
  end

  test "Admin User created with valid attributes", %{conn: conn} do
    admin = admin_fixture()
    attr = @create_attrs
    |> Map.put("username", admin.username)
    |> Map.put("password", admin.password)

    create_conn = post(conn, Routes.session_path(conn, :create), session: attr)
    assert redirected_to(create_conn) == Routes.admin_path(conn, :index)
    assert create_conn.private[:phoenix_flash]["info"] == "Welcome Back!"
  end

  test "render error on invalid user create", %{conn: conn} do
    admin_fixture()
    invalid_create_conn = post(conn, Routes.session_path(conn, :create), session: @invalid_attrs)
    assert html_response(invalid_create_conn, 200)
    assert invalid_create_conn.private[:phoenix_flash]["error"] == "Invalid username/password combination"
  end

end
