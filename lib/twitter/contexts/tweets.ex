defmodule Twitter.Tweets do
  import Ecto.Query

  alias Twitter.Repo
  alias Twitter.Tweets.Tweet

  def list_tweets() do
    Repo.all(Tweet)
  end

  def list_tweets_by_user_id(user_id) do
    Tweet
    |> where([tweet], tweet.user_id == ^user_id)
    |> Repo.all()
  end

  def get_tweet!(id) do
    Repo.get!(Tweet, id)
  end

  def create_tweet(params) do
    %Tweet{}
    |> Ecto.Changeset.cast(params, [:body, :user_id])
    |> Ecto.Changeset.validate_required([:user_id, :body])
    |> Repo.insert()
  end

  def delete_tweet(id) do
    tweet = get_tweet!(id)

    Repo.delete(tweet)
  end

  def update_tweet(tweet, params) do
    tweet
    |> Ecto.Changeset.cast(params, [:body, :user_id])
    |> Ecto.Changeset.validate_required([:user_id, :body])
    |> Repo.update()
  end
end
