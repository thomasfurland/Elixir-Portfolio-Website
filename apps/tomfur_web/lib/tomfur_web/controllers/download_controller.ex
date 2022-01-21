defmodule TomfurWeb.DownloadController do
  use TomfurWeb, :controller
  import Plug.Conn

  def resume(conn, _params) do
    path = Application.app_dir(:tomfur_web)
    |> Path.join("priv/static/Thomas-Furland-Resume2021.pdf")

    conn
    |> put_resp_content_type("application/pdf")
    |> send_file(200, path)
  end

end
