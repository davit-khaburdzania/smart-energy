defmodule SmartEnergyWeb.UserView do
  use SmartEnergyWeb, :view
  alias SmartEnergyWeb.UserView

  def render("show.json", %{user: user}) do
    render_one(user, UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, name: user.name, email: user.credential.email}
  end

  def render("jwt.json", %{jwt: jwt, user: user}) do
    %{jwt: jwt, user: render("user.json", %{user: user})}
  end
end
