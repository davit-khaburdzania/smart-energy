defmodule SmartEnergy.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias SmartEnergy.Accounts.{User, Credential}
  alias SmartEnergy.Devices.Device

  schema "users" do
    field :name, :string

    has_one :credential, Credential
    has_many :devices, Device

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def registration_changeset(%User{} = user, params) do
    user
    |> changeset(params)
    |> cast_assoc(:credential, with: &Credential.changeset/2, required: true)
  end
end
