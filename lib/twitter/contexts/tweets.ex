defmodule Twitter.Tweets do
  alias Twitter.Tweets.Tweet

  def list_tweets() do
    [
      %Tweet{id: 1, body: "Hello"},
      %Tweet{id: 2, body: "World"},
      %Tweet{id: 3, body: "This is Live_view"}
    ]
  end
end
