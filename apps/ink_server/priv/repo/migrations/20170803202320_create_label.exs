defmodule InkServer.Repo.Migrations.CreateLabel do
  use Ecto.Migration

  def change do
    create table(:labels) do
      add :color, :string
      add :name, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:labels, [:user_id])
  end
end
