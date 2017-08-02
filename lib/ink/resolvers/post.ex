defmodule Ink.Resolver.Post do
  import Ecto.Query, only: [where: 2]

  alias Ink.Repo
  alias Ink.Post

  def all(_args, _info) do
    {:ok, Repo.all(Post)}
  end

  def all_user_posts(_args, %{context: %{current_user: %{id: id}}}) do
    posts = Post
      |> where(user_id: ^id)
      |> Repo.all

    {:ok, posts}
  end

  def all_user_posts(_args, _info), do: {:error, "Not Authorized"}

  def find(%{uid: uid}, _info) do
    case Repo.get_by(Post, uid: uid) do
      nil -> {:error, "Post #{uid} not found"}
      post -> {:ok, post}
    end
  end

  def create(params, _info) do
    %Post{}
    |> Post.changeset(Post.add_secret(params))
    |> Repo.insert
    |> Post.add_uid
    |> Repo.update
  end

  def update(%{uid: uid, post: post_params}, _info) do
    Repo.get_by!(Post, uid: uid)
    |> Post.update_changeset(post_params)
    |> Repo.update
  end

  def delete(%{uid: uid}, _info) do
    post = Repo.get_by!(Post, uid: uid)
    Repo.delete(post)
  end
end
