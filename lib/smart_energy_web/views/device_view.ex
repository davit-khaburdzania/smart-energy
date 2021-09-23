defmodule SmartEnergyWeb.DeviceView do
  use SmartEnergyWeb, :view
  alias SmartEnergyWeb.{DeviceView, ConsumptionView}
  alias SmartEnergy.Devices

  def render("index.json", %{devices: devices}) do
    render_many(devices, DeviceView, "device.json")
  end

  def render("show.json", %{device: device}) do
    render_one(device, DeviceView, "device.json")
  end

  def render("device.json", %{device: device}) do
    cons_today = Devices.consumption_today_for(device)
    cons_last_30_days = Devices.consumptions_last_30_days_for(device)

    %{
      id: device.id,
      name: device.name,
      serial_number: device.serial_number,
      online: device.online,
      active: device.active,
      treshold: device.treshold,
      consumption_today: ConsumptionView.render("show.json", %{consumption: cons_today}),
      consumption_last_30_days: ConsumptionView.render("index.json", %{consumptions: cons_last_30_days})
    }
  end
end
