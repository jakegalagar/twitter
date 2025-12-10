defmodule TwitterWeb.UserLive.Index do
  use TwitterWeb, :live_view

  alias Twitter.Users

  def mount(_params, _session, socket) do
    users = Users.list_users()

    socket =
      socket
      |> assign(:users, users)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="p-4 border-b border-base-300">
      <h1 class="text-2xl font-bold">List Users</h1>
    </div>

    <!-- User List -->
    <%= for user <- @users do %>
      <div class="p-4 border-b border-base-300 hover:bg-base-200 transition flex items-center gap-4">
        
    <!-- Avatar -->
        <div class="avatar placeholder">
          <div class="bg-neutral text-neutral-content rounded-full w-12">
            <span>{first_letter(user.email)}</span>
          </div>
        </div>
        
    <!-- User info -->
        <div class="flex flex-col flex-grow">
          <span class="font-bold text-lg">{user.email}</span>
          <span class="text-sm opacity-60">@user</span>
        </div>
        
    <!-- Action -->
        <.link
          navigate={~p"/users/#{user}"}
          class="btn btn-sm btn-primary"
        >
          View
        </.link>
      </div>
    <% end %>
    """
  end

  defp first_letter(email) do
    email
    |> String.first()
    |> String.upcase()
  end
end
