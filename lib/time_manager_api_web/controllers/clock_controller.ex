
defmodule TimeManagerApiWeb.ClockController do
  use TimeManagerApiWeb, :controller

  alias TimeManagerApi.Clocks
  alias TimeManagerApi.Clocks.Clock

  action_fallback TimeManagerApiWeb.FallbackController

  def user_clocks(conn, %{"user_id" => user_id}) do
    clocks = Clocks.list_clocks_by_user(user_id)
    render(conn, :index, clocks: clocks)
  end

  def create_for_user(conn, %{"user_id" => user_id, "clock" => clock_params}) do
    attrs = Map.put(clock_params, "user_id", user_id)
    with {:ok, %Clock{} = clock} <- Clocks.create_clock(attrs) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clock}")
      |> render(:show, clock: clock)
    end
  end

  def index(conn, params) do
    case params do
      %{"user_id" => user_id} ->
        clocks = Clocks.list_clocks_by_user(user_id)
        render(conn, :index, clocks: clocks)
      _ ->
        clocks = Clocks.list_clocks()
        render(conn, :index, clocks: clocks)
    end
  end

  def create(conn, %{"clock" => clock_params}) do
    with {:ok, %Clock{} = clock} <- Clocks.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clock}")
      |> render(:show, clock: clock)
    end
  end

  def show(conn, %{"id" => id}) do
    clock = Clocks.get_clock!(id)
    render(conn, :show, clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Clocks.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Clocks.update_clock(clock, clock_params) do
      render(conn, :show, clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Clocks.get_clock!(id)

    with {:ok, %Clock{}} <- Clocks.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
