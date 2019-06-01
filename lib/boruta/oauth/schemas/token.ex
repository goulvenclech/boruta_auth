defmodule Boruta.Oauth.Token do
  use Ecto.Schema

  import Ecto.Changeset
  import Boruta.Config, only: [access_token_expires_in: 0, authorization_code_expires_in: 0]

  alias Boruta.Oauth.Client
  alias Boruta.Coherence.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tokens" do
    field(:type, :string)
    field(:value, :string)
    field(:redirect_uri, :string)
    field(:expires_at, :integer)

    belongs_to(:client, Client)
    belongs_to(:resource_owner, User)

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [])
    |> validate_required([])
  end

  def resource_owner_changeset(token, attrs) do
    token
    |> cast(attrs, [:client_id, :resource_owner_id])
    |> validate_required([:client_id, :resource_owner_id])
    |> put_change(:type, "access_token")
    # TODO better token randomization
    |> put_change(:value, SecureRandom.uuid)
    |> put_change(:expires_at, :os.system_time(:seconds) + access_token_expires_in())
  end

  def machine_changeset(token, attrs) do
    token
    |> cast(attrs, [:client_id])
    |> validate_required([:client_id])
    |> put_change(:type, "access_token")
    # TODO better token randomization
    |> put_change(:value, SecureRandom.uuid)
    |> put_change(:expires_at, :os.system_time(:seconds) + access_token_expires_in())
  end

  # TODO rename to code_changeset
  def authorization_code_changeset(token, attrs) do
    token
    |> cast(attrs, [:client_id, :resource_owner_id, :redirect_uri])
    |> validate_required([:client_id, :resource_owner_id, :redirect_uri])
    |> put_change(:type, "code")
    # TODO better token randomization
    |> put_change(:value, SecureRandom.uuid)
    |> put_change(:expires_at, :os.system_time(:seconds) + authorization_code_expires_in())
  end
end
