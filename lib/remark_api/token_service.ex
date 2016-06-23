defmodule RemarkApi.TokenService do
  @moduledoc """
  Provides functions in order to manage session tokens:
  - generate JWT token
  - verify JWT token

  ## Generate JWT token

  For generating JWT token the library [joken](https://github.com/bryanjos/joken) is used. The main
  information which is used for generation is user login. That login will be used in the verification
  process then. Be careful, each time the generator returns different tokens, because the current
  time is added to the token as well. It is implemented so to allow user has several tokens, because
  he can sign in from the different devices.

  ## Verify JWT token

  During the verification process the token is decoded and the resulting information is checked
  to contain proper `login` value inside.

  ## Configuration

  Encoding and decoding JWT tokens a secret key is used and this secret key only the server knows.
  To setup secret key add the following lines into `config/config.exs`:

  ```elixir
  config :remark_api,
    jwt_secret: "<YOUR_SECRET>"
  ```

  ## General usage

  ```elixir
  RemarkApi.TokenService.start_link

  RemarkApi.TokenService.generate_jwt("sergio") # => "1ex1e1z21x12.ex1212ez12.z1e12ze12"
  RemarkApi.TokenService.verify_jwt("23e2z323z23r.z23r23r2z3r23.z23rz23", "sergio") # => false
  ```

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
        worker(RemarkApi.TokenService, [])
      ]

      ...

      opts = [strategy: :one_for_one, name: RemarkApi.Supervisor]
      Supervisor.start_link(children, opts)
    end
  end
  ```
  
  """

  use GenServer

  @type jwt_token :: String.t
  @type user_login :: String.t

  @doc """
  Starts GenServer and used as entry point when you add this module as worker into supervisor
  tree.
  """
  def start_link(opts \\ []) do
    GenServer.start_link __MODULE__, :ok, name: TokenServiceServer
  end

  def init(:ok) do
    {:ok, 0}
  end

  @doc """
  Generates JWT token depending on the user's login and current milliseconds. It means that
  the same user can has many tokens and they are uniq.
  """
  @spec generate_jwt(user_login) :: jwt_token
  def generate_jwt(login) do
    GenServer.call TokenServiceServer, {:generate_jwt, login}
  end

  @doc """
  Verifies JWT token by decoding it and checking login in it.
  So thuthy value will be returned if:
  - token is successfully decoded;
  - contains proper information, in particular hash with `login` entry which contains proper value.
  """
  @spec verify_jwt(jwt_token, user_login) :: boolean
  def verify_jwt(jwt_token, login) do
    GenServer.call TokenServiceServer, {:verify_jwt, jwt_token, login}
  end

  def handle_call({:generate_jwt, login}, _from, state) do
    import Joken
    result = %{login: login, created_at: build_created_at}
              |> token
              |> with_signer(hs256(fetch_jwt_secret))
              |> sign 
              |> Map.get(:token)
    {:reply, result, state}
  end

  def handle_call({:verify_jwt, jwt_token, login}, _from, state) do
    import Joken
    result = jwt_token
              |> token
              |> with_validation("login", &(&1 == login))
              |> with_signer(hs256(fetch_jwt_secret))
              |> verify
              |> process_verified_token
    {:reply, result, state}
  end

  defp fetch_jwt_secret do
    Application.get_env(:remark_api, :jwt_secret)
  end

  defp build_created_at do
    :os.system_time(:milli_seconds)
  end

  defp process_verified_token(%Joken.Token{error: nil}), do: true
  defp process_verified_token(%Joken.Token{error: _reason}), do: false
end
