defmodule Ink.Repo.Migrations.CreatePostsLabels do
  use Ecto.Migration

  def change do
    create table(:labels_posts, primary_key: false) do
      add :label_id, references(:labels)
      add :post_id, references(:posts)
    end
  end
end
