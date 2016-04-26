defmodule RemarkApi.PaginationTest do
  use TestCaseWithDbSandbox, async: true

  alias RemarkApi.{Message, Repo, Pagination}

  test "only limiting" do
    create(:message)
    create(:message)
    pagination = %Pagination{per_page: 1}
    res = Message |> Pagination.apply(pagination) |> Repo.all
    assert Enum.count(res) == 1
  end

  test "filtering and limiting" do
    m1 = create(:message)
    m2 = create(:message)
    m3 = create(:message)
    pagination = %Pagination{last_message_id: m3.id, per_page: 2}
    res = Message |> Pagination.apply(pagination) |> Repo.all
    assert Enum.count(res) == 2
    ids = Enum.map(res, &(&1.id))
    assert Enum.member?(ids, m1.id)
    assert Enum.member?(ids, m2.id)
  end
end
