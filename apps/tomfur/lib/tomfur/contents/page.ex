defmodule Tomfur.Contents.Page do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
    id: integer(),
    name: String.t(),
    header: String.t(),
    main: String.t(),
    link1: String.t(),
    link2: String.t()
  }

  schema "pages" do
    field :name, :string
    field :header, :string
    field :main, :string
    field :link1, :string
    field :link2, :string

    timestamps()
  end

  @spec changeset(__MODULE__.t(), map()) :: Ecto.Changeset.t()
  def changeset(page, attrs) do
    page
    |> cast(attrs, [:name, :header, :main, :link1, :link2])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  @spec update_changeset(__MODULE__.t(), map()) :: Ecto.Changeset.t()
  def update_changeset(page, attrs) do
    page
    |> cast(attrs, [:name, :header, :main, :link1, :link2])
    |> validate_required([:name])
  end

end
