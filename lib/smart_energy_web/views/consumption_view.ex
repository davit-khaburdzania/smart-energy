defmodule SmartEnergyWeb.ConsumptionView do
  use SmartEnergyWeb, :view
  alias SmartEnergyWeb.ConsumptionView

  def render("index.json", %{consumptions: consumptions}) do
    render_many(consumptions, ConsumptionView, "consumption.json")
  end

  def render("show.json", %{consumption: consumption}) do
    render_one(consumption, ConsumptionView, "consumption.json")
  end

  def render("consumption.json", %{consumption: consumption}) do
    %{
      id: consumption.id,
      date: consumption.date,
      amount: consumption.amount
    }
  end
end
