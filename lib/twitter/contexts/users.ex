defmodule Twitter.Users do
  alias Twitter.Repo
  alias Twitter.Accounts.User

  def list_users() do
    Repo.all(User)
  end

  def get_user!(id) do
    Repo.get(User, id)
  end
end
