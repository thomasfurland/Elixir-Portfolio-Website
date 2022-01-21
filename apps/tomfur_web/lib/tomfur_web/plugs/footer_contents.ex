defmodule TomfurWeb.FooterContents do
  import Plug.Conn
  alias Tomfur.Contents

  def init(opts), do: opts

  def call(conn, _opts) do
    cond do
      footer_content = Contents.get_page_by(name: "footer") ->
        assign(conn, :footer, footer_content)
      true ->
        replacement = %Contents.Page{
          name: "footer",
          header: "",
          main: "",
          link1: "",
          link2: ""
        }
        assign(conn, :footer, replacement)
    end
  end
end
