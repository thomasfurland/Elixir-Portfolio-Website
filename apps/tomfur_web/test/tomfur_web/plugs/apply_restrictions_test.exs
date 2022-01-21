defmodule TomfurWeb.ApplyRestrictionsTest do
  use TomfurWeb.ConnCase, async: true
  alias TomfurWeb.ApplyRestrictions

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(TomfurWeb.Router, :browser)
      |> get("/")
    {:ok, %{conn: conn}}
  end

  test "plug halts when no current_user exists", %{conn: conn} do
    halted_conn =
      conn
      |> assign(:current_user, nil)
      |> ApplyRestrictions.call(%{})
    assert halted_conn.halted
  end

  test "plug not halted if current_user exists", %{conn: conn} do
    plug_conn =
      conn
      |> assign(:current_user, %Tomfur.Admin.User{})
      |> ApplyRestrictions.call(%{})
    refute plug_conn.halted
  end

end
