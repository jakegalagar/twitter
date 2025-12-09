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
    Listing Users
    <.table id="users" rows={@users}>
      <:col :let={user} label="ID">{user.id}</:col>
      <:col :let={user} label="Email">{user.email}</:col>
    </.table>
    """
  end
end
