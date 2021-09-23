defmodule SmartEnergy.DevicesTest do
  use SmartEnergy.DataCase

  alias SmartEnergy.Devices

  describe "devices" do
    alias SmartEnergy.Devices.Device

    @valid_attrs %{
      active: true,
      name: "some name",
      online: true,
      serial_number: "some serial_number"
    }
    @update_attrs %{
      active: false,
      name: "some updated name",
      online: false,
      serial_number: "some updated serial_number"
    }
    @invalid_attrs %{active: nil, name: nil, online: nil, serial_number: nil}

    def device_fixture(attrs \\ %{}) do
      {:ok, device} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Devices.create_device()

      device
    end

    test "list_devices/0 returns all devices" do
      device = device_fixture()
      assert Devices.list_devices() == [device]
    end

    test "get_device!/1 returns the device with given id" do
      device = device_fixture()
      assert Devices.get_device!(device.id) == device
    end

    test "create_device/1 with valid data creates a device" do
      assert {:ok, %Device{} = device} = Devices.create_device(@valid_attrs)
      assert device.active == true
      assert device.name == "some name"
      assert device.online == true
      assert device.serial_number == "some serial_number"
    end

    test "create_device/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Devices.create_device(@invalid_attrs)
    end

    test "update_device/2 with valid data updates the device" do
      device = device_fixture()
      assert {:ok, %Device{} = device} = Devices.update_device(device, @update_attrs)
      assert device.active == false
      assert device.name == "some updated name"
      assert device.online == false
      assert device.serial_number == "some updated serial_number"
    end

    test "update_device/2 with invalid data returns error changeset" do
      device = device_fixture()
      assert {:error, %Ecto.Changeset{}} = Devices.update_device(device, @invalid_attrs)
      assert device == Devices.get_device!(device.id)
    end

    test "delete_device/1 deletes the device" do
      device = device_fixture()
      assert {:ok, %Device{}} = Devices.delete_device(device)
      assert_raise Ecto.NoResultsError, fn -> Devices.get_device!(device.id) end
    end

    test "change_device/1 returns a device changeset" do
      device = device_fixture()
      assert %Ecto.Changeset{} = Devices.change_device(device)
    end
  end

  describe "consumptions" do
    alias SmartEnergy.Devices.Consumption

    @valid_attrs %{amount: 120.5, date: ~D[2010-04-17]}
    @update_attrs %{amount: 456.7, date: ~D[2011-05-18]}
    @invalid_attrs %{amount: nil, date: nil}

    def consumption_fixture(attrs \\ %{}) do
      {:ok, consumption} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Devices.create_consumption()

      consumption
    end

    test "list_consumptions/0 returns all consumptions" do
      consumption = consumption_fixture()
      assert Devices.list_consumptions() == [consumption]
    end

    test "get_consumption!/1 returns the consumption with given id" do
      consumption = consumption_fixture()
      assert Devices.get_consumption!(consumption.id) == consumption
    end

    test "create_consumption/1 with valid data creates a consumption" do
      assert {:ok, %Consumption{} = consumption} = Devices.create_consumption(@valid_attrs)
      assert consumption.amount == 120.5
      assert consumption.date == ~D[2010-04-17]
    end

    test "create_consumption/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Devices.create_consumption(@invalid_attrs)
    end

    test "update_consumption/2 with valid data updates the consumption" do
      consumption = consumption_fixture()

      assert {:ok, %Consumption{} = consumption} =
               Devices.update_consumption(consumption, @update_attrs)

      assert consumption.amount == 456.7
      assert consumption.date == ~D[2011-05-18]
    end

    test "update_consumption/2 with invalid data returns error changeset" do
      consumption = consumption_fixture()
      assert {:error, %Ecto.Changeset{}} = Devices.update_consumption(consumption, @invalid_attrs)
      assert consumption == Devices.get_consumption!(consumption.id)
    end

    test "delete_consumption/1 deletes the consumption" do
      consumption = consumption_fixture()
      assert {:ok, %Consumption{}} = Devices.delete_consumption(consumption)
      assert_raise Ecto.NoResultsError, fn -> Devices.get_consumption!(consumption.id) end
    end

    test "change_consumption/1 returns a consumption changeset" do
      consumption = consumption_fixture()
      assert %Ecto.Changeset{} = Devices.change_consumption(consumption)
    end
  end
end
