defmodule TomfurWeb.FooterContentsTest do
  use TomfurWeb.ConnCase
  alias TomfurWeb.FooterContents

  alias Tomfur.Contents

  @default_footer %Contents.Page{
    name: "footer",
    header: "",
    main: "",
    link1: "",
    link2: ""
  }

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(TomfurWeb.Router, :browser)
      |> get("/")
    {:ok, %{conn: conn}}
  end

  test "footer model populates params if exists", %{conn: conn} do
    page = content_fixture(%{name: "footer", header: "Custom Header"})
    conn = FooterContents.call(conn, %{})
    assert conn.assigns.footer == page
  end

  test "default footer model used if no model available", %{conn: conn} do
    conn = FooterContents.call(conn, %{})
    assert conn.assigns.footer == @default_footer
  end

end
