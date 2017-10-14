defmodule InkServer.Schema do
  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      alias __MODULE__
      alias InkServer.Repo
      alias InkServer.Schema

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id

      def preload(resource, includes) do
        InkServer.Repo.preload(resource, includes)
      end
    end
  end
end
