defmodule TimeManagerApi.WorkingtimesTest do
  use TimeManagerApi.DataCase

  alias TimeManagerApi.Workingtimes

  describe "workingtimes" do
    alias TimeManagerApi.Workingtimes.WorkingTime

    import TimeManagerApi.WorkingtimesFixtures

    @invalid_attrs %{start: nil, end: nil}

    test "list_workingtimes/0 returns all workingtimes" do
      working_time = working_time_fixture()
      assert Workingtimes.list_workingtimes() == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert Workingtimes.get_working_time!(working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time" do
      user = TimeManagerApi.UsersFixtures.user_fixture()
      valid_attrs = %{start: ~U[2025-09-23 10:15:00Z], end: ~U[2025-09-23 10:15:00Z], user_id: user.id}

      assert {:ok, %WorkingTime{} = working_time} = Workingtimes.create_working_time(valid_attrs)
      assert working_time.start == ~U[2025-09-23 10:15:00Z]
      assert working_time.end == ~U[2025-09-23 10:15:00Z]
      assert working_time.user_id == user.id
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Workingtimes.create_working_time(@invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time" do
      working_time = working_time_fixture()
      update_attrs = %{start: ~U[2025-09-24 10:15:00Z], end: ~U[2025-09-24 10:15:00Z]}

      assert {:ok, %WorkingTime{} = working_time} = Workingtimes.update_working_time(working_time, update_attrs)
      assert working_time.start == ~U[2025-09-24 10:15:00Z]
      assert working_time.end == ~U[2025-09-24 10:15:00Z]
    end

    test "update_working_time/2 with invalid data returns error changeset" do
      working_time = working_time_fixture()
      assert {:error, %Ecto.Changeset{}} = Workingtimes.update_working_time(working_time, @invalid_attrs)
      assert working_time == Workingtimes.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{}} = Workingtimes.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> Workingtimes.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset" do
      working_time = working_time_fixture()
      assert %Ecto.Changeset{} = Workingtimes.change_working_time(working_time)
    end
  end
end
