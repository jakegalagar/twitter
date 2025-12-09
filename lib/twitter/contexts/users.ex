defmodule Twitter.Users do

  alias Twitter.Repo
  alias Twitter.Accounts.User

  def list_users() do
    Repo.all(User)
  end
end
