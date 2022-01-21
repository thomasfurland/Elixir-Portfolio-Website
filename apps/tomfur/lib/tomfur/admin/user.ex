defmodule Tomfur.Admin.User do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
    id: integer(),
    name: String.t(),
    username: String.t(),
    password_hash: binary()
  }

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @spec changeset(__MODULE__.t(), map()) :: Ecto.Changeset.t()
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username])
    |> validate_length(:username, min: 1, max: 20)
    |> unique_constraint(:username)
  end

  @spec registration_changeset(__MODULE__.t(), map()) :: Ecto.Changeset.t()
  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast(params, [:password], [])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  @spec put_pass_hash(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  def put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))
      _ ->
        changeset
    end
  end

end
