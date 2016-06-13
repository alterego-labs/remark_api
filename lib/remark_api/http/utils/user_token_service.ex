defmodule RemarkApi.Http.Utils.UserTokenService do
  @moduledoc """
  Service in order to manage tokens:
  - attach new one
  - remove some token

  ## Use as worker

  This module can be added as worker to the supervisor tree, so it will be run automatically during
  the start time of your application.
  
  ```elixir
  defmodule RemarkApi do
    use Application

    def start(_type, _args) do
      import Supervisor.Spec, warn: false

      children = [
        ...
        worker(RemarkApi.Http.Utils.UserTokenService, [])
      ]

      ...

      opts = [strategy: :one_for_one, name: RemarkApi.Supervisor]
      Supervisor.start_link(children, opts)
    end
  end
  """

  use GenServer

  @type jwt_token :: String.t

  @doc """
  Starts GenServer and used as entry point when you add this module as worker into supervisor
  tree.
  """
  def start_link(opts \\ []) do
    GenServer.start_link __MODULE__, :ok, name: Http.Utils.UserTokenServiceServer
  end

  def init(:ok) do
    {:ok, 0}
  end

  @doc """
  Adds new token for the concrete user.
  The token which was added for the user will be returned as the function result.
  """
  @spec add_token(RemarkApi.User.t) :: jwt_token
  def add_token(user) do
    GenServer.call Http.Utils.UserTokenServiceServer, {:add_token, user}
  end

  @doc """
  Verifies user token.
  """
  @spec verify_token(jwt_token | :undefined | nil) :: boolean
  def verify_token(:undefined), do: false
  def verify_token(nil), do: false
  def verify_token(jwt_token) do
    GenServer.call Http.Utils.UserTokenServiceServer, {:verify_token, jwt_token}
  end

  def handle_call({:add_token, user}, _from, state) do
    result = RemarkApi.TokenService.generate_jwt(user.login)
              |> create_token_record(user.id)
              |> provide_add_token_response
    {:reply, result, state}
  end

  def handle_call({:verify_token, jwt_token}, _from, state) do
    result = jwt_token
              |> RemarkApi.Token.first_for_value
              |> process_verify_with_token
    {:reply, result, state}
  end

  defp create_token_record(jwt_token, user_id) do
    %RemarkApi.Token{}
    |> RemarkApi.Token.changeset(%{value: jwt_token, user_id: user_id})
    |> RemarkApi.Repo.insert
  end

  defp provide_add_token_response({:ok, token_record}) do
    token_record.value
  end

  defp process_verify_with_token(nil = _token_record), do: false
  defp process_verify_with_token(token_record) do
    login = token_record.user.login
    jwt_token = token_record.value
    RemarkApi.TokenService.verify_jwt(jwt_token, login)
  end
end
