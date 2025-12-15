defmodule TwitterWeb.UserLive.Show do
  use TwitterWeb, :live_view

  alias Twitter.Users
  alias Twitter.Tweets
  alias Twitter.Repo

  def mount(%{"id" => id}, _session, socket) do
    user =
      Users.get_user!(id)

    tweets =
      Tweets.list_tweets_by_user_id(id)
      |> Repo.preload(:user)

    socket =
      socket
      |> assign(:user, user)
      |> assign(:tweets, tweets)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <!-- PROFILE HEADER -->
    <div class="p-6 border-b border-base-300 flex items-center gap-4">

    <!-- Avatar -->
      <div class="avatar placeholder">
        <div class="bg-neutral text-neutral-content w-16 rounded-full">
          <span class="text-xl">{first_letter(@user.email)}</span>
        </div>
      </div>

    <!-- User Info -->
      <div>
        <h1 class="text-2xl font-bold">{@user.email}</h1>
        <p class="text-sm opacity-60">@user</p>
        <p class="text-sm mt-1 opacity-70">{length(@tweets)} Tweets</p>
      </div>

      <div class="flex-grow"></div>

    <!-- Back Button -->
      <.link navigate={~p"/users"} class="btn btn-sm">
        Back
      </.link>
    </div>

    <!-- USER TIMELINE -->
    <%= for tweet <- @tweets do %>
      <div class="p-4 border-b border-base-300 hover:bg-base-200 transition">

    <!-- Tweet Header -->
        <div class="flex items-center gap-2 text-sm">
          <div class="font-bold">
            {@user.email}
          </div>
        </div>

    <!-- Tweet Body -->
        <p class="mt-1">{tweet.body}</p>

    <!-- Timestamp -->
        <p class="text-xs opacity-60 mt-2">
          {format_datetime(tweet.inserted_at)}
        </p>
      </div>
    <% end %>
    """
  end

  defp first_letter(email) do
    if email == nil do
      nil
    else
      email
      |> String.first()
      |> String.upcase()
    end
  end

  defp format_datetime(dt) do
    Calendar.strftime(dt, "%b %d, %Y · %I:%M %p")
  end
end
