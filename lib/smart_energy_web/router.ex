defmodule SmartEnergyWeb.Router do
  use SmartEnergyWeb, :router
  alias SmartEnergy.Plugs.Guardian
  alias SmartEnergy.Plugs

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug(Guardian.AuthPipeline)
    plug(Plugs.CurrentUser)
  end

  scope "/api/v1", SmartEnergyWeb do
    pipe_through(:api)

    post("/sign_up", UserController, :create)
    post("/sign_in", UserController, :sign_in)
  end

  scope "/api/v1", SmartEnergyWeb do
    pipe_through([:api, :authenticated])

    get("/me", UserController, :show)
    resources("/devices", DeviceController, except: [:new, :edit])  do
      post("/active", DeviceController, :active)
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: SmartEnergyWeb.Telemetry
    end
  end
end
