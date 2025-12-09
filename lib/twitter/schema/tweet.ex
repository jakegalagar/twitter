defmodule Twitter.Tweets.Tweet do
  use Ecto.Schema

  alias Twitter.Accounts.User

  schema "tweets" do
    field :body, :string

    belongs_to :user, User

    timestamps(type: :utc_datetime_usec)
  end
end
