defmodule SmartEnergy.Devices.Consumption do
  use Ecto.Schema
  import Ecto.Changeset
  alias SmartEnergy.Devices.Device

  schema "consumptions" do
    field :amount, :float
    field :date, :date

    belongs_to :device, Device

    timestamps()
  end

  @doc false
  def changeset(consumption, attrs) do
    consumption
    |> cast(attrs, [:date, :amount])
    |> validate_required([:date, :amount])
  end
end
