defmodule Twitter.Repo.Migrations.CreateTweetsTable do
  use Ecto.Migration

  def change do
    create table("tweets") do
      add :body, :string

      timestamps(type: :utc_datetime_usec)
    end
  end
end
