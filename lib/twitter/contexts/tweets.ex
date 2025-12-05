defmodule Twitter.Tweets do
  alias Twitter.Repo
  alias Twitter.Tweets.Tweet

  def list_tweets() do
    Repo.all(Tweet)
  end

  def get_tweet!(id) do
    Repo.get!(Tweet, id)
  end

  def create_tweet(params) do
    %Tweet{}
    |> Ecto.Changeset.cast(params, [:body])
    |> Repo.insert()
  end
end
