defmodule Ink.Repo.Migrations.CreateNote do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :uid, :string
      add :secret, :string
      add :title, :string
      add :body, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:notes, [:uid])
    create index(:notes, [:uid, :secret])
    create index(:notes, [:user_id])
  end
end
