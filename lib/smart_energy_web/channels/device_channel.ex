defmodule SmartEnergy.DeviceChannel do
  use Phoenix.Channel
  alias SmartEnergy.Devices

  def join("device:" <> device_id, _params, socket) do
    device = Devices.get_device_by_serial_number(device_id)

    case device do
      nil ->
        {:ok, socket}

      device ->
        Devices.update_device(device, %{online: true})
        {:ok, assign(socket, :device, device)}
    end

    {:ok, socket}
  end

  def handle_in("set:active", %{"active" => active}, socket) do
    device = socket.assigns[:device]

    unless is_nil(device) do
      Devices.update_device(device, %{active: active})
    end

    {:noreply, socket}
  end

  def handle_in("set:consumption", %{"amount" => amount}, socket) do
    device = socket.assigns[:device]
    today = Date.utc_today

    unless is_nil(device) do
      with {:ok, cons} <- Devices.find_or_create_consumption(%{date: today, device_id: device.id}),
           {:ok, cons} <- Devices.update_consumption(cons, %{amount: cons.amount + amount}) do
        Devices.check_consumption_treshold(device, cons)
      end
    end

    {:noreply, socket}
  end

  def leave(socket, _topic) do
    device = socket.assigns[:device]

    unless is_nil(device) do
      Devices.update_device(device, %{online: false})
    end

    {:ok, socket}
  end
end
