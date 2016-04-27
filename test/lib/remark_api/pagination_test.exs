defmodule RemarkApi.PaginationTest do
  use TestCaseWithDbSandbox, async: true

  alias RemarkApi.{Message, Repo, Pagination}

  test "build with all nils" do
    res = Pagination.build(nil, nil)
    assert res.last_message_id == nil
    assert res.per_page == 10
  end

  test "build with integer values" do
    res = Pagination.build(1006, 15)
    assert res.last_message_id == 1006
    assert res.per_page == 15
  end

  test "build with string values" do
    res = Pagination.build("1006", "15")
    assert res.last_message_id == 1006
    assert res.per_page == 15
  end

  test "build with :undefined" do
    res = Pagination.build(:undefined, :undefined)
    assert res.last_message_id == nil
    assert res.per_page == 10
  end

  test "apply only limiting" do
    create(:message)
    create(:message)
    pagination = %Pagination{per_page: 1}
    res = Message |> Pagination.apply(pagination) |> Repo.all
    assert Enum.count(res) == 1
  end

  test "apply filtering and limiting" do
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
