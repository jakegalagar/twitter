defmodule TwitterWeb.TweetLive.Show do
  use TwitterWeb, :live_view

  alias Twitter.Tweets

  def mount(%{"id" => id}, _session, socket) do
    tweet = Tweets.get_tweet!(id)

    socket =
      socket
      |> assign(tweet: tweet)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>{@tweet.body}</h1>
    <p>{@tweet.inserted_at}</p>

    <.link navigate={~p"/tweets"}>
      <.button>
        Back
      </.button>
    </.link>
    """
  end
end
