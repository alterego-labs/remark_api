defmodule RemarkApi.HelperTest do
  use TestCaseWithDbSandbox, async: true

  alias RemarkApi.{Message}

  test "prettify simple errors" do
    res = RemarkApi.Helper.pretty_errors([body: "is required"])
    assert ["Body is required"] = res
  end

  test "prettify errors with variables" do
    res = RemarkApi.Helper.pretty_errors([
      login: {"should be at most %{count} character(s)", [count: 10]},
      message_body: "should not be blank"
    ])
    assert String.equivalent?(Enum.at(res, 0), "Login should be at most 10 character(s)")
    assert String.equivalent?(Enum.at(res, 1), "Message body should not be blank")
  end
end
