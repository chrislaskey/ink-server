defmodule InkServer.Note.Instance do
  alias InkServer.Repo
  alias InkServer.Note

  def owner?(uid, user_id) do
    case Repo.get_by(Note, %{uid: uid, user_id: user_id}) do
      nil -> {:error, "Note #{uid} not owned by user"}
      note -> {:ok, note}
    end
  end

  def labels(%Note{} = note) do
    Repo.preload(note, [:labels]).labels
  end
end
