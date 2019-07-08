# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Graphical.Repo.insert!(%Graphical.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Graphical.Accounts
alias Graphical.Posts

Accounts.create_user(%{name: "123", email: "123@lmk.com", password: "password"})
Accounts.create_user(%{name: "456", email: "456@lmk.com", password: "password"})

for _ <- 1..10 do
  Posts.create_post(%{
    title:    Faker.Lorem.sentence,
    body:     Faker.Lorem.paragraph,
    user_id:  [1, 2] |> Enum.take_random(1) |> hd
    })
end
