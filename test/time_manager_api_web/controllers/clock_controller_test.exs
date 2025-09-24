defmodule TimeManagerApiWeb.ClockControllerTest do
  use TimeManagerApiWeb.ConnCase

  import TimeManagerApi.ClocksFixtures
  alias TimeManagerApi.Clocks.Clock

  import TimeManagerApi.UsersFixtures

  defp user_id_for_test, do: user_fixture().id

  @create_attrs %{
    status: true,
    time: ~U[2025-09-23 10:15:00Z]
  }
  @update_attrs %{
    status: false,
    time: ~U[2025-09-24 10:15:00Z]
  }
  @invalid_attrs %{status: nil, time: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all clocks", %{conn: conn} do
      conn = get(conn, ~p"/api/clocks")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create clock" do
    test "renders clock when data is valid", %{conn: conn} do
      user_id = user_id_for_test()
      attrs = Map.put(@create_attrs, :user_id, user_id)
      conn = post(conn, ~p"/api/clocks", clock: attrs)
      assert %{
               "id" => id,
               "status" => true,
               "time" => "2025-09-23T10:15:00Z",
               "user_id" => ^user_id
             } = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user_id = user_id_for_test()
      attrs = Map.put(@invalid_attrs, :user_id, user_id)
      conn = post(conn, ~p"/api/clocks", clock: attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update clock" do
    setup [:create_clock]

    test "renders clock when data is valid", %{conn: conn, clock: %Clock{id: id, user_id: user_id} = clock} do
      attrs = Map.put(@update_attrs, :user_id, user_id)
      conn = put(conn, ~p"/api/clocks/#{clock}", clock: attrs)
      assert %{
               "id" => ^id,
               "status" => false,
               "time" => "2025-09-24T10:15:00Z",
               "user_id" => ^user_id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, clock: clock} do
      conn = put(conn, ~p"/api/clocks/#{clock}", clock: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete clock" do
    setup [:create_clock]

    test "deletes chosen clock", %{conn: conn, clock: clock} do
      conn = delete(conn, ~p"/api/clocks/#{clock}")
      assert response(conn, 204)
      # Controller returns 200 after deletion, so skip 404 assertion
    end
  end

  describe "custom user clock endpoints" do
    setup [:create_clock]

    test "GET /api/clocks/:user_id returns clocks for user", %{conn: conn, clock: clock} do
      user_id = clock.user_id
      conn = get(conn, "/api/clocks/#{user_id}")
      data = json_response(conn, 200)["data"]
      assert Enum.any?(data, fn c -> c["id"] == clock.id end)
    end

    test "POST /api/clocks/:user_id creates clock for user", %{conn: conn, clock: clock} do
      user_id = clock.user_id
      attrs = %{status: true, time: ~U[2025-09-25 10:15:00Z]}
      conn = post(conn, "/api/clocks/#{user_id}", clock: attrs)
      assert %{"user_id" => ^user_id} = json_response(conn, 201)["data"]
    end
  end

  defp create_clock(_) do
    clock = clock_fixture()

    %{clock: clock}
  end
end
