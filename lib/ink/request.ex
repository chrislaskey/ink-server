defmodule Ink.Request do
  alias Ink.CurrentUser

  def with_login(resolver) do
    fn (params, info) ->
      case CurrentUser.present?(info) do
        false -> {:error, "Not Authorized"}
        true -> resolver.(params, info)
      end
    end
  end
end
