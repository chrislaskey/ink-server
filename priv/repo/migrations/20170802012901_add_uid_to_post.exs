defmodule Ink.Repo.Migrations.AddUidToPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :uid, :string
    end

    create index(:posts, [:uid])
  end
end
