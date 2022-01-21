defmodule Tomfur.Email do
  import Swoosh.Email

  def contact(form) do
    new()
    |> to({"me", "me@email.com"})
    |> from({form.name, "test@emailservice.com"})
    |> subject(form.subject)
    |> html_body("<h1>#{form.email}</h1>")
    |> text_body(form.text)
  end

end
