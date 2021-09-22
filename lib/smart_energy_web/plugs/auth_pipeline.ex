defmodule SmartEnergy.Plugs.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :SmartEnergy,
    module: SmartEnergy.Guardian,
    error_handler: SmartEnergy.AuthErrorHandler

  plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
end
