defmodule TomfurWeb.DownloadControllerTest do
  use TomfurWeb.ConnCase, async: true

  test "GET /resume", %{conn: conn} do
    conn = get(conn, Routes.download_path(conn, :resume))
    assert response(conn, 200)
    assert response_content_type(conn, :pdf) =~ "charset=utf-8"
  end

end
