defmodule TwitterWeb.UserLive.Show do
  use TwitterWeb, :live_view

  alias Twitter.Users
  alias Twitter.Tweets

  def mount(%{"id" => id}, _session, socket) do
    user = Users.get_user!(id)
    tweets = Tweets.list_tweets_by_user_id(id)

    socket =
      socket
      |> assign(:user, user)
      |> assign(:tweets, tweets)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>
      Tweets for {@user.email}
    </h1>

    <.table id="tweets" rows={@tweets}>
      <:col :let={tweet} label="ID">{tweet.id}</:col>
      <:col :let={tweet} label="Body">{tweet.body}</:col>
      <:col :let={tweet} label="User ID">{tweet.user_id}</:col>
    </.table>

    <.link navigate={~p"/users"}>
      <.button>
        Back
      </.button>
    </.link>
    """
  end
end
