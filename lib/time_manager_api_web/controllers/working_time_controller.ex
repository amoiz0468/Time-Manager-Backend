# POST /api/workingtimes/:user_id
  # (moved inside module below)

defmodule TimeManagerApiWeb.WorkingTimeController do
  use TimeManagerApiWeb, :controller

  alias TimeManagerApi.Workingtimes
  alias TimeManagerApi.Workingtimes.WorkingTime

  action_fallback TimeManagerApiWeb.FallbackController

  def show_for_user(conn, %{"user_id" => user_id, "id" => id}) do
    working_time = Workingtimes.get_working_time!(id)
    if Integer.to_string(working_time.user_id) == user_id do
      render(conn, :show, working_time: working_time)
    else
      conn
      |> put_status(:not_found)
      |> json(%{"error" => "Working time not found for this user"})
    end
  end


  def index(conn, params) do
    case params do
      %{"user_id" => user_id} ->
        workingtimes = Workingtimes.list_workingtimes_by_user(user_id, params)
        render(conn, :index, workingtimes: workingtimes)
      _ ->
        workingtimes = Workingtimes.list_workingtimes()
        render(conn, :index, workingtimes: workingtimes)
    end
  end

  # GET /api/workingtimes/:user_id
  def user_workingtimes(conn, %{"user_id" => user_id} = params) do
    workingtimes = Workingtimes.list_workingtimes_by_user(user_id, params)
    render(conn, :index, workingtimes: workingtimes)
  end

  def create(conn, %{"working_time" => working_time_params}) do
    with {:ok, %WorkingTime{} = working_time} <- Workingtimes.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtimes/#{working_time}")
      |> render(:show, working_time: working_time)
    else
      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{"errors" => %{detail: "Could not create working_time"}})
    end
  end

  # POST /api/workingtimes/:user_id
  def create_for_user(conn, %{"user_id" => user_id, "working_time" => working_time_params}) do
    attrs = Map.put(working_time_params, "user_id", user_id)
    with {:ok, %WorkingTime{} = working_time} <- Workingtimes.create_working_time(attrs) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtimes/#{working_time}")
      |> render(:show, working_time: working_time)
    end
  end

  def show(conn, %{"id" => id}) do
    working_time = Workingtimes.get_working_time!(id)
    render(conn, :show, working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Workingtimes.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- Workingtimes.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    else
      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{"errors" => %{detail: "Could not update working_time"}})
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Workingtimes.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Workingtimes.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
