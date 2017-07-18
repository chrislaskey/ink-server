# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Ink.Repo.insert!(%Ink.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Ink.User
alias Ink.Post
alias Ink.Repo

Repo.insert!(%User{name: "Chris Laskey", email: "contact@chrislaskey.com"})
Repo.insert!(%User{name: "Denali", email: "denali@chrislaskey.com"})

Enum.map(1..10, fn(_) ->
  Ink.Repo.insert!(%Post{
    title: Faker.Lorem.sentence,
    body: Faker.Lorem.paragraph,
    user_id: [1, 2] |> Enum.take_random(1) |> hd
  })
end)

### Alternative way using a Module to organize code:

# defmodule Ink.Seeds do
#   def generate_posts() do
#     Ink.Repo.insert!(%Post{
#       title: Faker.Lorem.sentence,
#       body: Faker.Lorem.paragraph,
#       user_id: [1, 2] |> Enum.take_random(1) |> hd
#     })
#   end
# end

# Long form:
# Enum.map(1..10, fn(_) -> Ink.Seeds.generate_posts(_) end)

# Short form (using & syntax):
# Enum.map(1..10, &Ink.Seeds.generate_posts(&1))

### Alternative way using `for`:

# for _ <- 1..10 do
#   Repo.insert!(%Post{})
# end
