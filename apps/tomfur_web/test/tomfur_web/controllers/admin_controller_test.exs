defmodule TomfurWeb.AdminControllerTest do
  use TomfurWeb.ConnCase, async: true
  alias Tomfur.Admin

  test "require user authentication on all actions", %{conn: conn} do
    Enum.each([
      get(conn, Routes.admin_path(conn, :index)),
      get(conn, Routes.admin_path(conn, :new)),
      post(conn, Routes.admin_path(conn, :create, %{}))
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  describe "with a logged-in user" do
    setup %{conn: conn} do
      admin = admin_fixture(username: "tommy")
      conn = assign(conn, :current_user, admin)

      {:ok, conn: conn, user: admin}
    end

    @create_attrs %{
      name: "Admin Tom",
      username: "Admin",
      password: "123456"
    }
    @invalid_attrs %{username: ""}

    defp admin_count, do: Enum.count(Admin.list_users())

    test "displays Admin Backend Correctly", %{conn: conn} do
      conn = get(conn, Routes.admin_path(conn, :index))
      assert html_response(conn, 200) =~ "Admin Backend"
    end

    test "Admin User created with valid attributes", %{conn: conn} do
      start_count = admin_count()
      create_conn = post(conn, Routes.admin_path(conn, :create), user: @create_attrs)
      assert redirected_to(create_conn) == Routes.admin_path(conn, :index)
      assert Admin.get_user_by(name: @create_attrs.name)
      assert admin_count() == start_count + 1
    end

    test "render error on invalid user create", %{conn: conn} do
      start_count = admin_count()
      invalid_create_conn = post(conn, Routes.admin_path(conn, :create), user: @invalid_attrs)
      assert html_response(invalid_create_conn, 200) =~ "Check the errors"
      assert admin_count() == start_count
    end

  end

end
