defmodule Ink.Repo.Migrations.CreateNotesLabels do
  use Ecto.Migration

  def change do
    create table(:labels_notes, primary_key: false) do
      add :label_id, references(:labels)
      add :note_id, references(:notes)
    end
  end
end
