defmodule SmartEnergy.DevicesTest do
  use SmartEnergy.DataCase

  alias SmartEnergy.{Devices, Accounts}

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
      {:ok, user} = Accounts.create_user(%{name: "Test user"})

      {:ok, device} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Devices.create_device(user)

      device
    end

    test "create_device/1 with valid data creates a device" do
      {:ok, user} = Accounts.create_user(%{name: "Test user"})
      assert {:ok, %Device{} = device} = Devices.create_device(@valid_attrs, user)
      assert device.active == true
      assert device.name == "some name"
      assert device.online == true
      assert device.serial_number == "some serial_number"
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
  end
end
