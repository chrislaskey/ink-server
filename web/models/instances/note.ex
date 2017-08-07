defmodule Ink.Note.Instance do
  alias Ink.Repo
  alias Ink.Note

  def owner?(uid, user_id) do
    case Repo.get_by(Note, %{uid: uid, user_id: user_id}) do
      nil -> {:error, "Note #{uid} not owned by user"}
      post -> {:ok, post}
    end
  end

  def labels(%Note{} = post) do
    Repo.preload(post, [:labels]).labels
  end
end
