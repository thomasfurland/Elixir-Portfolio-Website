defmodule Tomfur.Repo.Migrations.CreatePage do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :name, :string, null: false
      add :header, :string
      add :main, :string
      add :link1, :string
      add :link2, :string

      timestamps()
    end
    
    create unique_index(:pages, [:name])
  end
end
