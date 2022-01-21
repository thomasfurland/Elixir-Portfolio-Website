defmodule TomfurWeb.PageViewTest do
  use TomfurWeb.ConnCase, async: true
  import Phoenix.View
  alias Tomfur.Contents.Page
  alias TomfurWeb.PageView

  @pages [
    %Page{id: 1, name: "footer", header: "Test Header"},
    %Page{id: 2, name: "about", header: "Test Header", main: "Test Main"},
    %Page{id: 3, name: "contact", header: "Test Header", main: "Test Main"}
  ]

  test "renders index.html", %{conn: conn} do
    content = render_to_string(PageView, "index.html", conn: conn, pages: @pages)

    assert String.contains?(content, "Admin Backend Pages")
    for page <- @pages do
      assert String.contains?(content, page.name)
    end

  end

  test "renders about.html", %{conn: conn} do
    about = Enum.at(@pages, 1)
    content = render_to_string(PageView, "about.html", conn: conn, content: about)
    assert String.contains?(content, about.header)
    assert String.contains?(content, about.main)
  end

  test "renders contact.html", %{conn: conn} do
    contact = Enum.at(@pages, 2)
    content = render_to_string(PageView, "contact.html", conn: conn, content: contact)
    assert String.contains?(content, contact.header)
    assert String.contains?(content, contact.main)
  end

end
