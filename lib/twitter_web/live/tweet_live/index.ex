defmodule TwitterWeb.TweetLive.Index do
  use TwitterWeb, :live_view

  alias Twitter.Tweets
  alias Twitter.Tweets.Tweet

  def mount(_params, _session, socket) do
    tweets = Tweets.list_tweets()

    socket =
      socket
      |> assign(:tweets, tweets)

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> apply_action(socket.assigns.live_action, params)

    {:noreply, socket}

  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  defp apply_action(socket, :new, params) do
    socket
    |> assign(:tweet, %Tweet{})
  end

  def render(assigns) do
    ~H"""
    <h1>Listing Tweets</h1>

    <.link navigate={~p"/tweets/new"}>
      <.button>New</.button>
    </.link>

    <.table id="tweets" rows={@tweets}>
      <:col :let={tweet} label="ID">{tweet.id}</:col>
      <:col :let={tweet} label="Body">{tweet.body}</:col>
      <:action :let={tweet}>
        <.link navigate={~p"/tweets/#{tweet}"}>
          show
        </.link>
      </:action>
    </.table>

    <%= if @live_action == :new do %>
      <.modal id="tweet-modal" show>
        <.live_component
          id={:new}
          module={TwitterWeb.TweetLive.FormComponent}
          tweet={@tweet}
        />
      </.modal>
    <% end %>
    """
  end
end
