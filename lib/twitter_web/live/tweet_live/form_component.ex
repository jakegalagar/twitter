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
        <.button>save</.button>
      </.simple_form>
    </div>
    """
  end

  def handle_event("save-tweet", %{"tweet" => tweet_params}, socket) do
    Tweets.create_tweet(tweet_params)

    message =
      "Tweet was created successfully."

    socket =
      socket
      |> put_flash(:info, message)
      |> push_navigate(to: ~p"/tweets")

    {:noreply, socket}
  end
end
