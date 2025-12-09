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

  def delete_tweet(id) do
    tweet = get_tweet!(id)

    Repo.delete(tweet)
  end

  def update_tweets(tweet, params) do
    tweet
    |> Ecto.Changeset.cast(params, [:body])
    |> Repo.update()
  end
end
