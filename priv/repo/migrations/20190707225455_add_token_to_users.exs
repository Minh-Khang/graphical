defmodule Graphical.Repo.Migrations.AddTokenToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :token, :text # use :text to store over 255 characters in Database
    end
  end
end
