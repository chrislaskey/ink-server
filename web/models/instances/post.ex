defmodule Ink.Post.Instance do
  alias Ink.Repo
  alias Ink.Post

  def owner?(uid, user_id) do
    case Repo.get_by(Post, %{uid: uid, user_id: user_id}) do
      nil -> {:error, "Post #{uid} not owned by user"}
      post -> {:ok, post}
    end
  end

  def labels(%Post{} = post) do
    Repo.preload(post, [:labels]).labels
  end
end
