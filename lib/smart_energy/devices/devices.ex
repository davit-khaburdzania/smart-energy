defmodule SmartEnergy.Devices do
  import Ecto.Query, warn: false
  alias SmartEnergy.Repo

  alias SmartEnergy.Devices.{Device, Consumption}
  alias SmartEnergy.Accounts.User

  def list_devices do
    Repo.all(Device)
  end

  def list_devices_for_user(user) do
    Device
    |> user_devices_query(user)
    |> Repo.all()
  end

  def get_device!(id), do: Repo.get!(Device, id)

  def get_device_by_serial_number(serial_number) do
    Device
    |> Repo.get_by(serial_number: serial_number)
  end

  def create_device(attrs \\ %{}, user) do
    %Device{}
    |> Device.changeset(attrs)
    |> put_user(user)
    |> Repo.insert()
  end

  def update_device(%Device{} = device, attrs) do
    device
    |> Device.changeset(attrs)
    |> Repo.update()
  end

  def delete_device(%Device{} = device) do
    Repo.delete(device)
  end

  def change_device(%Device{} = device, attrs \\ %{}) do
    Device.changeset(device, attrs)
  end

  def create_consumption(attrs \\ %{}) do
    %Consumption{}
    |> Consumption.changeset(attrs)
    |> Repo.insert()
  end

  def update_consumption(%Consumption{} = cons, attrs) do
    cons
    |> Consumption.changeset(attrs)
    |> Repo.update()
  end

  def find_or_create_consumption(attrs) do
    cons = Repo.find_by(Consumption, attrs)

    case cons do
      nil -> create_consumption(attrs)
      cons -> {:ok, cons}
    end
  end

  def consumption_today_for(device) do
    today = Date.utc_today()
    attrs = %{date: today, device_id: device.id}

    Repo.find_by(Consumption, attrs)
  end

  def consumptions_last_30_days_for(device) do
    today = Date.utc_today()
    last_30_days = Date.add(today, -30)

    query =
      from(c in Consumption,
        where: c.date >= ^last_30_days,
        where: c.date <= ^today
      )

    Repo.all(query)
  end

  def check_consumption_treshold(device, consumption) do
    if device.treshold && device.treshold > consumption.amount do
      # TODO Implement push notification logic
      IO.puts("Device daily treshold exceeded")
    end
  end

  defp put_user(changeset, %User{} = user) do
    Ecto.Changeset.put_assoc(changeset, :user, user)
  end

  defp user_devices_query(query, %User{id: id}) do
    from(v in query,
      where: v.user_id == ^id,
      order_by: [desc: v.updated_at]
    )
  end
end
