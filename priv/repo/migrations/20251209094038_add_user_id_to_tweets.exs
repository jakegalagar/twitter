defmodule Twitter.Repo.Migrations.AddUserIdToTweets do
  use Ecto.Migration

  def change do
    alter table("tweets") do
      add :user_id, references("users")
    end
  end
end
