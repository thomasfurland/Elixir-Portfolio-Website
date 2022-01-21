defmodule TomfurWeb.Router do
  use TomfurWeb, :router

  pipeline :browser do
    #plug :introspect, "From Cowboy"
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TomfurWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug TomfurWeb.FooterContents
    #plug :introspect, "Before Controller"
  end

  pipeline :admin do
    plug TomfurWeb.Auth
    plug TomfurWeb.ApplyRestrictions
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TomfurWeb do
    pipe_through :browser
    get "/", ProjectController, :index
    get "/about", PageController, :about
    get "/contact", PageController, :contact
    post "/send", PageController, :send
    resources "/skill", SkillController, only: [:index, :new, :create]
    resources "/session", SessionController, only: [:new, :create, :delete]
  end

  scope "/admin", TomfurWeb do
    pipe_through :browser
    pipe_through :admin
    resources "/", AdminController, only: [:index, :new, :create]
    resources "/pages", PageController, only: [:index, :new, :create, :edit, :update]
  end

  scope "/downloads", TomfurWeb do
    pipe_through :browser
    get "/", DownloadController, :resume
  end

  # Other scopes may use custom stacks.
  # scope "/api", TomfurWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TomfurWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  def introspect(conn, label ) do
    IO.inspect(conn, label: label)
  end

end
