defmodule SmartEnergyWeb.UserController do
  use SmartEnergyWeb, :controller

  alias SmartEnergy.Accounts
  alias SmartEnergy.Accounts.User
  alias SmartEnergy.Guardian

  action_fallback(SmartEnergyWeb.FallbackController)

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Accounts.login_by_email_and_pass(email, password) do
      {:ok, user, token} ->
        conn |> render("jwt.json", jwt: token, user: user)

      _ ->
        {:error, :unauthorized}
    end
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.register_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn |> render("jwt.json", jwt: token, user: user)
    end
  end

  def show(conn, _params) do
    user = Accounts.preload_user(conn.assigns.current_user, :credential)
    conn |> render("user.json", user: user)
  end
end
