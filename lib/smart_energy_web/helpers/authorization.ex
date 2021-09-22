defmodule SmartEnergy.Controllers.Helpers.Authorization do
  use SmartEnergyWeb, :controller

  def handle_unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "Not Authorized"})
  end

  def not_found_handler(conn) do
    conn
    |> put_status(:not_found)
    |> render(SmartEnergyWeb.ErrorView, :"404")
  end
end
