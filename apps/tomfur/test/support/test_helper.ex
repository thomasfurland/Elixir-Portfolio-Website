defmodule Tomfur.TestHelpers do

  alias Tomfur.Admin
  alias Tomfur.Contents

  def admin_fixture(attrs \\ %{}) do
    {:ok, admin} =
      attrs
      |> Enum.into(%{
        name: "New User",
        username: "user#{System.unique_integer([:positive])}",
        password: attrs[:password] || "password"
      })
      |> Admin.register_user()

      admin
  end

  def content_fixture(attrs \\ %{}) do
    {:ok, content} =
      attrs
      |> Enum.into(%{
        name: "New Page",
        header: "New Page Header",
        main: "new main content",
        link1: "",
        link2: ""
      })
      |> Contents.create_page()

      content
  end
end
