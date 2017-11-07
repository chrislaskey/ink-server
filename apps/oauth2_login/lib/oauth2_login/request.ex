defmodule OAuth2Login.Request do
  alias OAuth2Login.Request.User

  def with_login(resolver) do
    fn (params, info) ->
      case User.present?(info) do
        false -> {:error, "Not Authorized"}
        true -> resolver.(params, info)
      end
    end
  end
end
