defmodule Ink.Repo.Migrations.AddSecretToPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :secret, :string
    end

    create index(:posts, [:uid, :secret])
  end
end
