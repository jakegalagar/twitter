defmodule TwitterWeb.TweetLive.Show do
  use TwitterWeb, :live_view

  alias Twitter.Repo
  alias Twitter.Tweets

  def mount(%{"id" => id}, _session, socket) do
    tweet =
      Tweets.get_tweet!(id)
      |> Repo.preload(:user)

    patch = ~p"/tweets/#{id}"

    socket =
      socket
      |> assign(tweet: tweet)
      |> assign(patch: patch)

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> apply_action(socket.assigns.live_action, params)

    {:noreply, socket}
  end

  defp apply_action(socket, :show, _params) do
    socket
  end

  defp apply_action(socket, :edit, _params) do
    socket
    |> assign(:page_title, "Edit Tweet")
  end

  def render(assigns) do
    ~H"""
    <div class="p-4 border-b border-base-300">

    <!-- User + Avatar -->
      <div class="flex items-center gap-3">
        <div class="avatar placeholder">
          <div class="bg-neutral text-neutral-content w-10 rounded-full">
            <span>{first_letter(@tweet.user && @tweet.user.email)}</span>
          </div>
        </div>

        <div class="flex flex-col">
          <span class="font-bold text-lg">
            {(@tweet.user && @tweet.user.email) || "Unknown User"}
          </span>
          <span class="text-sm opacity-60">@user</span>
        </div>
      </div>

      <p class="text-xl mt-4 mb-2">
        {@tweet.body}
      </p>

      <div class="opacity-60 text-sm border-b border-base-300 pb-4">
        {format_datetime(@tweet.inserted_at)}
      </div>

      <div class="mt-4 flex gap-4">
        <.link patch={~p"/tweets/#{@tweet}/show/edit"} class="btn btn-sm btn-primary">
          Edit
        </.link>

        <.link navigate={~p"/tweets"} class="btn btn-sm">
          Back
        </.link>
      </div>
    </div>

    <%= if @live_action == :edit do %>
      <.modal id="edit-tweet-modal" show on_cancel={JS.patch(@patch)}>
        <.live_component
          id={@tweet.id}
          module={TwitterWeb.TweetLive.FormComponent}
          tweet={@tweet}
          patch={@patch}
          page_title={@page_title}
          live_action={@live_action}
        />
      </.modal>
    <% end %>
    """
  end

  defp first_letter(nil) do
    nil
  end

  defp first_letter(email) do
    email
    |> String.first()
    |> String.upcase()
  end

  # Nice readable timestamp like Twitter
  defp format_datetime(dt) do
    Phoenix.HTML.Safe.to_iodata(Calendar.strftime(dt, "%b %d, %Y · %I:%M %p"))
  end
end
