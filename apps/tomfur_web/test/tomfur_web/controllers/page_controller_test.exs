defmodule TomfurWeb.PageControllerTest do
  use TomfurWeb.ConnCase, async: true

  alias Tomfur.Contents

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each([
      get(conn, Routes.page_path(conn, :index)),
      get(conn, Routes.page_path(conn, :new)),
      get(conn, Routes.page_path(conn, :edit, "123")),
      put(conn, Routes.page_path(conn, :update, "123", %{})),
      post(conn, Routes.page_path(conn, :create, %{}))
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  test "about page display content", %{conn: conn} do
    content_fixture(name: "about")
    conn = get conn, Routes.page_path(conn, :about)
    assert html_response(conn, 200) =~ ~r/New Page Header/
  end

  test "contact page display content", %{conn: conn} do
    content_fixture(name: "contact")
    conn = get conn, Routes.page_path(conn, :contact)
    assert html_response(conn, 200) =~ ~r/New Page Header/
  end

  test "email sent successfully display content", %{conn: conn} do
    email = %{"page" => %{
      "email" => "",
      "name" => "",
      "subject" => "",
      "text" => ""
    }}
    conn = post conn, Routes.page_path(conn, :send, email)
    assert redirected_to(conn) == Routes.page_path(conn, :contact)
    assert conn.private[:phoenix_flash]["info"] == "Email Sent!"
  end

  describe "with a logged-in user" do
    setup %{conn: conn} do
      admin = admin_fixture(username: "tommy")
      conn = assign(conn, :current_user, admin)

      {:ok, conn: conn, user: admin}
    end

    @create_attrs %{
      name: "About",
      header: "Hi I'm Thomas",
      main: "this is main text",
      link1: "http://test.com",
      link2: ""
    }
    @invalid_attrs %{main: "invalid"}

    defp page_count, do: Enum.count(Contents.list_pages())

    test "lists all admins's pages on index", %{conn: conn} do
      test_content = content_fixture()
      conn = get conn, Routes.page_path(conn, :index)
      assert html_response(conn, 200) =~ ~r/Admin Backend Pages/
      assert String.contains?(conn.resp_body, test_content.name)
    end

    test "creates page and redirects", %{conn: conn} do
      create_conn = post conn, Routes.page_path(conn, :create), page: @create_attrs
      assert redirected_to(create_conn) == Routes.page_path(conn, :index)
      assert Contents.get_page_by(name: @create_attrs.name)
      assert page_count() == 1
    end

    test "invalid input doesn't create page, renders error", %{conn: conn} do
      invalid_conn = post conn, Routes.page_path(conn, :create), page: @invalid_attrs
      assert html_response(invalid_conn, 200) =~ "Check the errors"
      assert page_count() == 0
    end

    test "updates page and redirects with params", %{conn: conn} do
      page = content_fixture()
      refute Contents.get_page_by(name: @create_attrs.name)

      update_conn = put conn, Routes.page_path(conn, :update, page.id), page: @create_attrs
      assert %{id: id} = redirected_params(update_conn)
      assert redirected_to(update_conn) == Routes.page_path(conn, :edit, id)

      assert Contents.get_page_by(name: @create_attrs.name)
      assert page_count() == 1
    end

    test "GET admin/page/new", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :new))
      assert html_response(conn, 200) =~ "Register"
    end

    test "GET admin/page/edit/id", %{conn: conn} do
      page = content_fixture()
      conn = get(conn, Routes.page_path(conn, :edit, page.id))
      assert html_response(conn, 200) =~ "Edit"
    end
  end
end
