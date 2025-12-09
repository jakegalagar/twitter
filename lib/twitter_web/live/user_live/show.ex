defmodule TwitterWeb.UserLive.Show do
  use TwitterWeb, :live_view

  alias Twitter.Users

  def mount(%{"id" => id}, _session, socket) do
     user = Users.get_user!(id)

     socket =
      socket
      |> assign(:user, user)


    {:ok, socket}

  end

  def render(assigns) do
    ~H"""
    <h1>
      Tweets for {@user.email}
    </h1>

    <.link navigate={~p"/users"}>
      <.button>
        Back
      </.button>
    </.link>
    """
  end
end
