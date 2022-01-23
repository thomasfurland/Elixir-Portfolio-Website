defmodule Tomfur.EmailTest do
  use ExUnit.Case, async: true

  import Swoosh.TestAssertions
  alias Tomfur.Mailer
  alias Tomfur.Email

  test "sends valid email successfully" do
    form = %{email: "email", name: "name", subject: "subject", text: "text"}
    email = Email.contact(form)
    Mailer.deliver(email)
    assert_email_sent email
  end

end
