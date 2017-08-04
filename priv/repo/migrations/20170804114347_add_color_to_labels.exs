defmodule Ink.Repo.Migrations.AddColorToLabels do
  use Ecto.Migration

  def change do
    alter table(:labels) do
      add :color, :string
    end
  end
end
