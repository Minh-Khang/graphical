defmodule Graphical.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Graphical.Accounts.User
  alias Graphical.Repo

  schema "users" do
    field :email, :string
    field :name, :string
    field :token, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :posts, Graphical.Posts.Post

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email], [:password])
    |> validate_required([:name, :email])
    |> put_pass_hash
  end

  def registration_changset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> put_pass_hash
  end

  def store_token_changeset(user, attrs) do
    user
    |> cast(attrs, [:token])
    |> validate_required([:token])
    |> put_pass_hash
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset

  def authenticate(params) do
    user = Repo.get_by(User, email: String.downcase(params.email))
    case verify_user(user, params.password) do
      true -> {:ok, user}
      _ -> {:error, "Incorrect login credenticals"}
    end
  end

  def verify_user(user, password) do
    case user do
      nil -> false
      _ -> Argon2.verify_pass(password, user.password_hash) # Argon2.verify_pass require not null on password_hash
    end
  end
end
