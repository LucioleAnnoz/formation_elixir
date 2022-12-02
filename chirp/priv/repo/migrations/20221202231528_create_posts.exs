defmodule Chirp.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :author, :string
      add :body, :string
      add :likes_count, :integer
      add :reposts_count, :integer

      timestamps()
    end
  end
end
