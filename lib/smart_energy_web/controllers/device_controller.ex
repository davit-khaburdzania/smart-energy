defmodule SmartEnergyWeb.ProjectController do
  use SmartEnergyWeb, :controller

  alias SmartEnergy.Devices
  alias SmartEnergy.Devices.Device
  alias SmartEnergyWeb.Endpoint

  action_fallback(SmartEnergyWeb.FallbackController)

  plug(:load_and_authorize_resource, model: Device)

  def index(conn, _params) do
    devices = current_user(conn) |> Devices.list_devices_for_user()
    render(conn, "index.json", devices: devices)
  end

  def create(conn, %{"device" => device_params}) do
    with {:ok, %Device{} = device} <-
           Devices.create_device(device_params, current_user(conn)) do
      conn
      |> put_status(:created)
      |> render("show.json", device: device)
    end
  end

  def show(conn, _params) do
    render(conn, "show.json", device: conn.assigns.device)
  end

  def update(conn, %{"device" => device_params}) do
    device = conn.assigns.device

    with {:ok, %Device{} = device} <- Devices.update_device(device, device_params) do
      render(conn, "show.json", device: device)
    end
  end

  def active(conn, %{"active" => active}) do
    device = conn.assigns.device
    payload = %{active: active}

    with :ok <- Endpoint.broadcast("devices:" <> device.serial_number, "set:active", payload) do
      render(conn, "show.json", device: device)
    end
  end

  def delete(conn, _params) do
    with {:ok, %Device{}} <- Devices.delete_device(conn.assigns.device) do
      send_resp(conn, :no_content, "")
    end
  end

  defp current_user(conn), do: Guardian.Plug.current_resource(conn)
end
