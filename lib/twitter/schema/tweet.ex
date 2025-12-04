defmodule Twitter.Tweets.Tweet do
  use Ecto.Schema
  # defstruct [:id, :body]
  schema "tweets" do
    field :body, :string

    timestamps(type: :utc_datetime_usec)
  end
end
