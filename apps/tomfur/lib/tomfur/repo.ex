defmodule Tomfur.Repo do
  use Ecto.Repo,
    otp_app: :tomfur,
    adapter: Ecto.Adapters.Postgres
end
