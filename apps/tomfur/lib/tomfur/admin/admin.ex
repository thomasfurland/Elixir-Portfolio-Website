defmodule Tomfur.Admin do

  alias Tomfur.Repo
  alias Tomfur.Admin.User

  @spec change_user(User.t()) :: Ecto.Changeset.t()
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @spec create_user(map()) :: {:ok, struct()} | {:error, Ecto.Changeset.t()}
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @spec change_registration(User.t(), map()) :: Ecto.Changeset.t()
  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

  @spec register_user(map()) :: {:ok, struct()} | {:error, Ecto.Changeset.t()}
  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @spec get_user(integer()) :: User.t()
  def get_user(id) do
    Repo.get(User, id)
  end

  @spec get_user_by(term) :: User.t()
  def get_user_by(param) do
    Repo.get_by(User, param)
  end

  @spec authenticate_by_username_and_pass(String.t(), String.t()) :: {:ok, User.t()} | {:error, :unauthorized | :not_found}
  def authenticate_by_username_and_pass(username, given_pass) do
    user = get_user_by(username: username)

    cond do
      user && Pbkdf2.verify_pass(given_pass, user.password_hash) ->
        {:ok, user}
      user ->
        {:error, :unauthorized}
      true ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end

  def list_users do
    Repo.all(User)
  end

end
