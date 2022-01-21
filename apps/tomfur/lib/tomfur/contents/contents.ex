defmodule Tomfur.Contents do
    @moduledoc """
  A Module for Getting Site Contents to Display.
  Contents are stored in PostgreSQL
  """
  alias Tomfur.Repo
  alias Tomfur.Contents.Page

  @spec change_page(Page.t()) :: Ecto.Changeset.t()
  def change_page(%Page{} = page) do
    Page.changeset(page, %{})
  end

  @spec create_page(map()) :: {:ok, struct()} | {:error, Ecto.Changeset.t()}
  def create_page(attrs \\ %{}) do
    %Page{}
    |>Page.changeset(attrs)
    |>Repo.insert()
  end

  @spec update_page(integer, map()) :: {:ok, struct()} | {:error, Ecto.Changeset.t()}
  def update_page(id, attrs) do
    get_page!(id)
    |>Page.update_changeset(attrs)
    |>Repo.update()
  end

  @spec get_page!(integer()) :: Page.t()
  def get_page!(id) do
    Repo.get!(Page, id)
  end

  @spec get_page_by(any) :: Page.t()
  def get_page_by(param) do
    Repo.get_by(Page, param)
  end

  @spec list_pages :: list(Page.t())
  def list_pages do
    Repo.all(Page)
  end

end
