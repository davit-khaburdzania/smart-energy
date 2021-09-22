defmodule SmartEnergy.Accounts do
  alias SmartEnergy.Repo
  alias SmartEnergy.Accounts.User
  import Ecto.Query
  import Comeonin.Bcrypt, only: [checkpw: 2]

  def list_users do
    Repo.all(User)
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def preload_user(user, preloads \\ []) do
    Repo.preload(user, preloads)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def create_user(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  def register_user(params) do
    %User{}
    |> User.registration_changeset(params)
    |> Repo.insert()
  end

  def get_user_by_email(email) do
    from(u in User, join: c in assoc(u, :credential), where: c.email == ^email)
    |> Repo.one()
    |> Repo.preload(:credential)
  end

  def login_by_email_and_pass(email, pass) do
    case get_user_by_email(email) do
      %User{} = user -> check_password(user, pass)
      {:error, _reason} -> {:error, :unauthorized}
      _ -> {:error, :unauthorized}
    end
  end

  defp check_password(user, pass) do
    if checkpw(pass, user.credential.password_hash) do
      {:ok, user, SmartEnergy.Guardian.encode_and_sign(user) |> elem(1)}
    else
      {:error, :unauthorized}
    end
  end
end
