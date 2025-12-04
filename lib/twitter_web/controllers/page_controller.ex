defmodule TwitterWeb.PageController do
  use TwitterWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
