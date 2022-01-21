defmodule TomfurWeb.PageController do
  use TomfurWeb, :controller

  alias Tomfur.Email, as: Email
  alias Tomfur.Contents
  alias Tomfur.Contents.Page

  def about(conn, _params) do
    content = Contents.get_page_by(name: "about")
    render(conn, "about.html", content: content)
  end
  def contact(conn, _params) do
    content = Contents.get_page_by(name: "contact")
    render(conn, "contact.html", content: content)
  end

  def send(conn, %{"page" => %{"email" => email, "name" => name, "subject" => subject, "text" => text}}) do
    email = Email.contact(%{email: email, name: name, subject: subject, text: text})
    case Tomfur.Mailer.deliver(email) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Email Sent!")
        |> redirect(to: Routes.page_path(conn, :contact))
      {:error, _} ->
        conn
        |> put_flash(:error, "Email not Sent")
        |> redirect(to: Routes.page_path(conn, :contact))
    end
  end

  def index(conn, _params) do
    content = Contents.list_pages
    render(conn, "index.html", pages: content)
  end

  def new(conn, _params) do
    changeset = Contents.change_page(%Page{})
    render(conn, "new.html", changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    page = Contents.get_page!(id)
    changeset = Contents.change_page(page)
    render(conn, "edit.html", changeset: changeset, id: page.id)
  end

  def create(conn, %{"page" => page_params}) do
    case Contents.create_page(page_params) do
      {:ok, page} ->
        conn
        |> put_flash(:info, "#{page.name} registered!")
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "page" => page_params}) do
    case Contents.update_page(id, page_params) do
      {:ok, page} ->
        conn
        |> put_flash(:info, "#{page.name} updated!")
        |> redirect(to: Routes.page_path(conn, :edit, page.name))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

end
