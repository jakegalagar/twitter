defmodule TwitterWeb.TweetLive.Index do
  use TwitterWeb, :live_view

  alias Twitter.Tweets

  def mount(_params, _session, socket) do
    tweets = Tweets.list_tweets()

    socket =
      socket
      |> assign(:tweets, tweets)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Listing Tweets</h1>

    <.table id="tweets" rows={@tweets}>
      <:col :let={tweet} label="ID">{tweet.id}</:col>
      <:col :let={tweet} label="Body">{tweet.body}</:col>
      <:action :let={tweet}>
        <.link navigate={~p"/tweets/#{tweet}"}>
          show
        </.link>
      </:action>
    </.table>
    """
  end
end
