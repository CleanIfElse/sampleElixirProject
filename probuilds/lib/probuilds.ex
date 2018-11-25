defmodule Probuilds do
  @moduledoc """
  Documentation for Probuilds.
  """

  # User information
  def addUser(region, name, realName) do
    Accounts.getUserInformation(region, name, realName)
    |>Accounts.addAccount()
  end

  # insert recent match history
  def recentMatches() do
    Helperfunction.getAccountId()
    |> Matches.matchHistoryId()
  end

end
