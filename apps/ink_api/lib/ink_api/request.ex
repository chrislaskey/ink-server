defmodule InkApi.Request do
  alias InkApi.CurrentUser

  def with_login(resolver) do
    fn (params, info) ->
      case CurrentUser.present?(info) do
        false -> {:error, "Not Authorized"}
        true -> resolver.(params, info)
      end
    end
  end
end
