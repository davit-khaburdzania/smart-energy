defmodule SmartEnergy.Repo.Migrations.AddTresholdToDevices do
  use Ecto.Migration

  def change do
    alter table(:devices) do
      add :treshold, :float
    end
  end
end
