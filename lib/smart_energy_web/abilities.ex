alias SmartEnergy.Accounts.User
alias SmartEnergy.Devices.Device

defimpl Canada.Can, for: User do
  # Device Abilities
  def can?(%User{id: _user_id}, action, Device) when action in [:index, :create],
    do: true

  def can?(%User{id: user_id}, action, %Device{user_id: creator_id})
      when action in [:show, :update, :delete],
      do: user_id == creator_id
end
