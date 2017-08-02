defmodule Ink.Tools.Secret do
  @characters "123456789abdegjklmnopqrvwxyzABDEGJKLMNOPQRVWXYZ"
  @charlist String.split(@characters, "")

  def create(length \\ 40) do
    Enum.reduce((1..length), [], fn (_i, acc) ->
      [Enum.random(@charlist) | acc]
    end) |> Enum.join("")
  end
end
