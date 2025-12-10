defmodule TwitterWeb.TweetLive.FormComponent do
  use TwitterWeb, :live_component

  alias Twitter.Tweets

  def update(assigns, socket) do
    changeset = Ecto.Changeset.change(assigns.tweet)
    form = to_form(changeset)

    socket =
      socket
      |> assign(assigns)
      |> assign(:form, form)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.header>
        New Tweet
      </.header>

      <.simple_form for={@form} phx-target={@myself} phx-submit="save-tweet">
        <.input field={@form[:body]} label="Body" />
        <.input field={@form[:user_id]} label="User ID" />
        <.button>save</.button>
      </.simple_form>
    </div>
    """
  end

  def handle_event("save-tweet", %{"tweet" => tweet_params}, socket) do
    if socket.assigns.live_action == :new do
      Tweets.create_tweet(tweet_params)
    else
      tweet = socket.assigns.tweet
      Tweets.update_tweets(tweet, tweet_params)
    end

    message =
      if socket.assigns.live_action == :new do
        "Tweet was created successfully."
      else
        "Tweet was Update successfully."
      end

    socket =
      socket
      |> put_flash(:info, message)
      |> push_navigate(to: ~p"/tweets")

    {:noreply, socket}
  end
end
