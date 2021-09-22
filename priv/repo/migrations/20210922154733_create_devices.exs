defmodule SmartEnergy.Repo.Migrations.CreateDevices do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :name, :string
      add :serial_number, :string
      add :online, :boolean, default: false, null: false
      add :active, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:devices, [:user_id])
  end
end
