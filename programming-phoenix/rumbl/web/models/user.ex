defmodule Rumbl.User do
  use Rumbl.Web, :model

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    timestamps
  end

  def changeset(model, params \\ :empty) do
    model
      # cast:
      #  - converts that naked map to a changeset
      #  - limits the inbound parameters for security reason
      |> cast(params, ~w(name username), [])

      # validation
      |> validate_length(:username, min: 1, max: 20)
  end
end