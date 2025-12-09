defmodule TwitterWeb.TweetLive.Index do
  use TwitterWeb, :live_view

  alias Twitter.Repo
  alias Twitter.Tweets
  alias Twitter.Tweets.Tweet

  def mount(_params, _session, socket) do
    IO.inspect(socket.assigns)

    tweets = Tweets.list_tweets()
    tweets = Repo.preload(tweets, [:user])

    patch = ~p"/tweets"

    socket =
      socket
      |> assign(:tweets, tweets)
      |> assign(:patch, patch)

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

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:tweet, %Tweet{})
  end

  def render(assigns) do
    ~H"""
    <h1>Listing Tweets</h1>
    <div class="flex justify-end mb-4">
      <.link navigate={~p"/tweets/new"}>
        <.button>New</.button>
      </.link>
    </div>

    <.table id="tweets" rows={@tweets}>
      <:col :let={tweet} label="ID">{tweet.id}</:col>
      <:col :let={tweet} label="Body">{tweet.body}</:col>
      <:col :let={tweet} label="User ID">{tweet.user_id}</:col>
      <:col :let={tweet} label="User Email">{tweet.user && tweet.user.email}</:col>
      <:action :let={tweet}>
        <.link navigate={~p"/tweets/#{tweet}"}>
          show
        </.link>

        <.link
          phx-click="upcase"
          phx-value-id={tweet.id}
        >
          Up case
        </.link>

        <.link
          phx-click="downcase"
          phx-value-id={tweet.id}
        >
          down case
        </.link>

        <.link
          phx-click="delete-tweet"
          phx-value-id={tweet.id}
        >
          Delete
        </.link>
      </:action>
    </.table>

    <%= if @live_action == :new do %>
      <.modal id="tweet-modal" show on_cancel={JS.patch(@patch)}>
        <.live_component
          id={:new}
          module={TwitterWeb.TweetLive.FormComponent}
          tweet={@tweet}
          live_action={@live_action}
        />
      </.modal>
    <% end %>
    """
  end

  def handle_event("delete-tweet", %{"id" => id}, socket) do
    Tweets.delete_tweet(id)

    socket =
      socket
      |> put_flash(:info, "Tweet was Deleted successfully.")
      |> push_navigate(to: ~p"/tweets")

    {:noreply, socket}
  end

  def handle_event("upcase", %{"id" => id}, socket) do
    tweet = Repo.get(Tweet, id)

    upcase_body = String.upcase(tweet.body)

    tweet
    |> Ecto.Changeset.change(%{body: upcase_body})
    |> Repo.update()

    socket =
      socket
      |> put_flash(:info, "Body was Update successfully.")
      |> push_navigate(to: ~p"/tweets")

    {:noreply, socket}
  end

  def handle_event("downcase", %{"id" => id}, socket) do
    tweet = Repo.get(Tweet, id)

    downcase_body = String.downcase(tweet.body)

    tweet
    |> Ecto.Changeset.change(%{body: downcase_body})
    |> Repo.update()

    socket =
      socket
      |> put_flash(:info, "Body was downcase successfully")
      |> push_navigate(to: ~p"/tweets")

    {:noreply, socket}
  end
end
