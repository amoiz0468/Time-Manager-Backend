defmodule TimeManagerApiWeb.Router do
  use TimeManagerApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TimeManagerApiWeb do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
  get "/clocks/:user_id", ClockController, :user_clocks
  post "/clocks/:user_id", ClockController, :create_for_user
  resources "/clocks", ClockController, except: [:new, :edit]

  get "/workingtimes/:user_id", WorkingTimeController, :user_workingtimes
  get "/workingtimes/:user_id/:id", WorkingTimeController, :show_for_user
  post "/workingtimes/:user_id", WorkingTimeController, :create_for_user
  resources "/workingtimes", WorkingTimeController, except: [:new, :edit]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:time_manager_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TimeManagerApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
