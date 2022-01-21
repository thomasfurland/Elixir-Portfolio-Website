defmodule Tomfur.AdminTest do
    use Tomfur.DataCase, async: true
    doctest Tomfur.Admin

    alias Tomfur.Admin
    alias Tomfur.Admin.User

    describe "register_user/1" do
      @valid_attrs %{
          name: "User",
          username: "tommy",
          password: "secret"
      }
      @invalid_attrs %{}

      test "with valid data insert user" do
        assert {:ok, %User{id: id}=user} = Admin.register_user(@valid_attrs)
        assert user.name == "User"
        assert user.username == "tommy"
        assert [%User{id: ^id}] = Admin.list_users()
      end

      test "with invalid data does not insert user" do
        assert {:error, _changeset} = Admin.register_user(@invalid_attrs)
        assert Admin.list_users() == []
      end

      test "enforces unique usernames" do
        assert {:ok, %User{id: id}} = Admin.register_user(@valid_attrs)
        assert {:error, changeset} =  Admin.register_user(@valid_attrs)

        assert %{username: ["has already been taken"]} = errors_on(changeset)
        assert [%User{id: ^id}] = Admin.list_users()
      end

      test "does not accept long usernames" do
        attrs = Map.put(@valid_attrs, :username, String.duplicate("a", 30))
        {:error, changeset} = Admin.register_user(attrs)

        assert %{username: ["should be at most 20 character(s)"]} = errors_on(changeset)
        assert Admin.list_users() == []
      end

      test "requires password to be at least 6 char long" do
        attrs = Map.put(@valid_attrs, :password, "12345")
        {:error, changeset} = Admin.register_user(attrs)

        assert %{password: ["should be at least 6 character(s)"]} = errors_on(changeset)
        assert Admin.list_users() == []

      end

    end

    describe "authenticate_by_username_and_pass/2" do
      @pass "123456"

      setup do
        {:ok, user: admin_fixture(password: @pass)}
      end

      test "returns user with correct password", %{user: user} do
        assert {:ok, auth_user} = Admin.authenticate_by_username_and_pass(user.username, @pass)
        assert auth_user.id == user.id
      end

      test "returns unauthorized error with invalid password", %{user: user} do
        assert {:error, :unauthorized} = Admin.authenticate_by_username_and_pass(user.username, "badpass")
      end

      test "returns not found error with no matching user for email" do
        assert {:error, :not_found} = Admin.authenticate_by_username_and_pass("unknownuser", @pass)
      end

    end

end
