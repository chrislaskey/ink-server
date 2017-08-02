defmodule Ink.Uid do
  @characters "123456789abdegjklmnopqrvwxyz"

  @coder Hashids.new([
    alphabet: @characters,
    min_len: 3,
    # salt: System.get_env("UID_SALT")
  ])

  def encode(id) do
    Hashids.encode(@coder, id)
  end

  def decode(data) do
    Hashids.decode(@coder, data)
  end
end
