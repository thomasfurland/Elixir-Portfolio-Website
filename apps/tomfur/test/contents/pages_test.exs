defmodule Tomfur.PagesTest do
    use Tomfur.DataCase, async: true
    doctest Tomfur.Contents

    alias Tomfur.Contents
    alias Tomfur.Contents.Page

    @valid_attrs %{
        name: "Page Name",
        header: "This is Page Name",
        main: "",
        link1: "",
        link2: ""
    }
    @invalid_attrs %{}

    test "creates page with valid attributes" do
      assert {:ok, page = %Page{id: id}} = Contents.create_page(@valid_attrs)
      assert page.name == "Page Name"
      assert page.header == "This is Page Name"
      assert [%Page{id: ^id}] = Contents.list_pages()
    end

    test "won't create page with invalid attributes" do
      assert {:error, changeset} = Contents.create_page(@invalid_attrs)
      assert Contents.list_pages() == []
    end

    test "enforces unique page names" do
      assert {:ok, %Page{name: name}} = Contents.create_page(@valid_attrs)
      assert {:error, changeset} = Contents.create_page(@valid_attrs)

      assert %{name: ["has already been taken"]} = errors_on(changeset)
      assert [%Page{name: ^name}] = Contents.list_pages()
    end

end
