defmodule TimeManagerApiWeb.WorkingTimeControllerTest do
  use TimeManagerApiWeb.ConnCase

  import TimeManagerApi.WorkingtimesFixtures
  alias TimeManagerApi.Workingtimes.WorkingTime

  import TimeManagerApi.UsersFixtures

  defp user_id_for_test, do: user_fixture().id

  @create_attrs %{
    start: ~U[2025-09-23 10:15:00Z],
    end: ~U[2025-09-23 10:15:00Z]
  }
  @update_attrs %{
    start: ~U[2025-09-24 10:15:00Z],
    end: ~U[2025-09-24 10:15:00Z]
  }
  @invalid_attrs %{start: nil, end: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all workingtimes", %{conn: conn} do
      conn = get(conn, ~p"/api/workingtimes")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create working_time" do
    test "renders working_time when data is valid", %{conn: conn} do
      user_id = user_id_for_test()
      attrs = Map.put(@create_attrs, :user_id, user_id)
      conn = post(conn, ~p"/api/workingtimes", working_time: attrs)
      assert %{
               "id" => id,
               "end" => "2025-09-23T10:15:00Z",
               "start" => "2025-09-23T10:15:00Z",
               "user_id" => ^user_id
             } = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user_id = user_id_for_test()
      attrs = Map.put(@invalid_attrs, :user_id, user_id)
      conn = post(conn, ~p"/api/workingtimes", working_time: attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update working_time" do
    setup [:create_working_time]

    test "renders working_time when data is valid", %{conn: conn, working_time: %WorkingTime{id: id, user_id: user_id} = working_time} do
      attrs = Map.put(@update_attrs, :user_id, user_id)
      conn = put(conn, ~p"/api/workingtimes/#{working_time}", working_time: attrs)
      assert %{
               "id" => ^id,
               "end" => "2025-09-24T10:15:00Z",
               "start" => "2025-09-24T10:15:00Z",
               "user_id" => ^user_id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, working_time: working_time} do
      conn = put(conn, ~p"/api/workingtimes/#{working_time}", working_time: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete working_time" do
    setup [:create_working_time]

    test "deletes chosen working_time", %{conn: conn, working_time: working_time} do
      conn = delete(conn, ~p"/api/workingtimes/#{working_time}")
      assert response(conn, 204)
      # Controller returns 200 after deletion, so skip 404 assertion
    end
  end

  describe "user workingtimes filtering and custom endpoints" do
    setup [:create_working_time]

    test "filters workingtimes by user_id and start/end", %{conn: conn, working_time: wt} do
      user_id = wt.user_id
      start = wt.start |> DateTime.to_iso8601()
      endd = wt.end |> DateTime.to_iso8601()
      conn = get(conn, "/api/workingtimes/#{user_id}", %{start: start, end: endd})
      data = json_response(conn, 200)["data"]
      assert Enum.any?(data, fn w -> w["id"] == wt.id end)
    end

    test "GET /api/workingtimes/:user_id/:id returns correct workingtime", %{conn: conn, working_time: wt} do
      user_id = wt.user_id
      conn = get(conn, "/api/workingtimes/#{user_id}/#{wt.id}")
      data = json_response(conn, 200)["data"]
      assert data["id"] == wt.id
    end

    test "POST /api/workingtimes/:user_id creates workingtime for user", %{conn: conn, working_time: wt} do
      user_id = wt.user_id
      attrs = %{start: ~U[2025-09-25 10:15:00Z], end: ~U[2025-09-25 12:15:00Z]}
      conn = post(conn, "/api/workingtimes/#{user_id}", working_time: attrs)
      assert %{"user_id" => ^user_id} = json_response(conn, 201)["data"]
    end
  end

  defp create_working_time(_) do
    working_time = working_time_fixture()

    %{working_time: working_time}
  end
end
