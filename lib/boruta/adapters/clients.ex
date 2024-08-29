defmodule Boruta.ClientsAdapter do
  @moduledoc """
  Encapsulate injected `Boruta.Oauth.Clients` adapter in context configuration
  """

  @behaviour Boruta.Oauth.Clients
  @behaviour Boruta.Openid.Clients

  import Boruta.Config, only: [clients: 0]

  def get_client(id), do: clients().get_client(id)
  def get_client_by_did(did), do: clients().get_client_by_did(did)
  def public!, do: clients().public!()
  def authorized_scopes(params), do: clients().authorized_scopes(params)
  def list_clients_jwk, do: clients().list_clients_jwk()
  def create_client(registration_params), do: clients().create_client(registration_params)
  def refresh_jwk_from_jwks_uri(client_id), do: clients().refresh_jwk_from_jwks_uri(client_id)
end
