defmodule TwitterWeb.TweetLive.Show do
  use TwitterWeb, :live_view

  alias Twitter.Tweets

  def mount(%{"id" => id}, _session, socket) do
    tweet = Tweets.get_tweet!(id)
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
    <h1>{@tweet.body}</h1>
    <p>{@tweet.inserted_at}</p>

    <table class="table-auto w-full border">
      <thead>
        <tr class="bg-gray-100">
          <th class="border px-2 py-1">Field</th>
          <th class="border px-2 py-1">Value</th>
        </tr>

        <tr>
          <td class="border px-2 py-1 font-medium">ID:</td>
          <td class="border px-2 py-1">{@tweet.id}</td>
        </tr>

        <tr>
          <td class="border px-2 py-1 font-medium">Body:</td>
          <td class="border px-2 py-1">{@tweet.body}</td>
        </tr>
      </thead>
    </table>

    <div class="flex justify-end mb-4">
      <.link patch={~p"/tweets/#{@tweet}/show/edit"}>
        <.button>
          Edit
        </.button>
      </.link>
    </div>

    <div class="flex justify-end mb-4">
      <.link navigate={~p"/tweets"}>
        <.button>
          Back
        </.button>
      </.link>
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
end
