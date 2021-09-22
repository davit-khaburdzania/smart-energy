defmodule SmartEnergy.Devices.Device do
  use Ecto.Schema
  import Ecto.Changeset
  alias SmartEnergy.Accounts.User

  schema "devices" do
    field :active, :boolean, default: false
    field :name, :string
    field :online, :boolean, default: false
    field :serial_number, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(device, attrs) do
    device
    |> cast(attrs, [:name, :serial_number, :online, :active])
    |> validate_required([:name, :serial_number, :online, :active])
  end
end
