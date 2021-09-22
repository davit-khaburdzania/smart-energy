defmodule SmartEnergy.Repo.Migrations.CreateConsumptions do
  use Ecto.Migration

  def change do
    create table(:consumptions) do
      add :date, :date
      add :amount, :float
      add :device_id, references(:devices, on_delete: :nothing)

      timestamps()
    end

    create index(:consumptions, [:device_id])
  end
end
