defmodule TwitterWeb.TweetLive.FormComponent do
  use TwitterWeb, :live_component

  alias Twitter.Accounts.User
  alias Twitter.Tweets
  alias Twitter.Repo

  def update(assigns, socket) do
    changeset = Ecto.Changeset.change(assigns.tweet)
    form = to_form(changeset)

    options_for_user_id =
      User
      |> Repo.all()
      |> Enum.map(fn user -> {user.email, user.id} end)
      #[{"Jake", 1}, {"John", 2}, {"Anton", 3}]

    socket =
      socket
      |> assign(assigns)
      |> assign(:options_for_user_id, options_for_user_id)
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
        <.input type="text" field={@form[:body]} label="Body" />
        <.input type="select" field={@form[:user_id]} options={@options_for_user_id} label="User ID" />
        <.button>save</.button>
      </.simple_form>
    </div>
    """
  end

  def handle_event("save-tweet", %{"tweet" => tweet_params}, socket) do
    socket = save_tweet(socket, socket.assigns.live_action, tweet_params)

    {:noreply, socket}
  end

  defp save_tweet(socket, :new, tweet_params) do
    case Tweets.create_tweet(tweet_params) do
      {:ok, _tweet} ->
        socket
        |> put_flash(:info, "Tweet was created successfully.")
        |> push_navigate(to: ~p"/tweets")

      {:error, changeset} ->
        form = to_form(changeset)

        socket
        |> assign(:form, form)
    end
  end

  defp save_tweet(socket, :edit, tweet_params) do
    tweet = socket.assigns.tweet

    case Tweets.update_tweet(tweet, tweet_params) do
      {:ok, _tweet} ->
        message = "Tweet was Update successfully."

        socket
        |> put_flash(:info, message)
        |> push_navigate(to: ~p"/tweets")

      {:error, changeset} ->
        form = to_form(changeset)

        socket
        |> assign(:form, form)
    end
  end
end
