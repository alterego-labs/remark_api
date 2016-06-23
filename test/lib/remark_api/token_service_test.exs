defmodule RemarkApi.TokenGeneratorTest do
  use ExUnit.Case

  test "generate jwt based on login" do
    jwt_token = RemarkApi.TokenService.generate_jwt("sergio")
    assert is_bitstring(jwt_token)
  end

  test "verify jwt when token is valid returns truthy value" do
    jwt_token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJsb2dpbiI6InNlcmdpbyIsIndoZW4iOjE0NjUzMDcxODc4ODZ9.3x8dwXZ_jrluMWeGuVm8x6tOK76xKMOYInzrzS4IxIw"
    login = "sergio"
    assert RemarkApi.TokenService.verify_jwt(jwt_token, login)
  end

  test "verify jwt when token is broken returns falsey value" do
    jwt_token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJsb2dpbiI6InNlcmdpbyIsIndoZW4iOjE0NjUzMDcxODc4ODZ9.3x8dwXZ_jrluMWeGuVm8x6tOK76xKMOYInzrzS4IxIW"
    login = "sergio"
    refute RemarkApi.TokenService.verify_jwt(jwt_token, login)
  end
end
