defmodule InkServer.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :username, :string
      add :first_name, :string
      add :last_name, :string
      add :name, :string
      add :password_hash, :string
      add :locale, :string
      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
