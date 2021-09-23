defmodule SmartEnergyWeb.DeviceController do
  use SmartEnergyWeb, :controller
  use PhoenixSwagger

  alias SmartEnergy.Devices
  alias SmartEnergy.Devices.Device
  alias SmartEnergyWeb.Endpoint

  action_fallback(SmartEnergyWeb.FallbackController)

  plug(:load_and_authorize_resource, model: Device)

  swagger_path :index do
    get("/devices")
    summary("Get connected devicess")
    description("Get list of all the connected devices to currently authenticated user account")
    produces("application/json")
    tag("Devices")
    operation_id("list_devices")
    response(200, "OK", Schema.ref(:Devices))
    response(400, "Client Error")
  end

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

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/devices/{id}")
    summary("Remove Device")
    description("Remove device from connected devices list")
    tag("Devices")
    parameter(:id, :path, :integer, "Device ID", required: true, example: 3)
    response(203, "No Content - Deleted Successfully")
  end

  def delete(conn, _params) do
    with {:ok, %Device{}} <- Devices.delete_device(conn.assigns.device) do
      send_resp(conn, :no_content, "")
    end
  end

  defp current_user(conn), do: Guardian.Plug.current_resource(conn)

  def swagger_definitions do
    %{
      Device:
        swagger_schema do
          title("Device")
          description("A device of the application")

          properties do
            id(:string, "Unique identifier", required: true)
            name(:string, "Device name", required: true)
            serial_number(:string, "Device serial number")
            active(:boolean, "Device status")
            online(:boolean, "Is device connected and online")
            treshold(:float, "Daily consumption treshold for device")
          end

          example(%{
            id: "113",
            name: "Home TV plug",
            serial_number: "96dfe374-c732-4e45-af08-63b289704e49",
            active: true,
            online: true,
            treshold: 23.5
          })
        end,
      Devices:
        swagger_schema do
          title("Devices")
          description("A collection of Devices")
          type(:array)
          items(Schema.ref(:Device))
        end
    }
  end
end
