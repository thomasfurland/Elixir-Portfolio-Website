defmodule Tomfur.Projects.Project do

  @type t :: %__MODULE__{
    id: integer(),
    name: String.t(),
    url: String.t(),
    demo: boolean(),
    description: String.t(),
    homepage: String.t(),
    date: DateTime.t()
  }
  defstruct [:id, :name, :url, :demo, :description, :homepage,:date]
end
