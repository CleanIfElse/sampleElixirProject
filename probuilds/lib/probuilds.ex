defmodule Probuilds do
  @moduledoc """
  Documentation for Probuilds.
  """

  ###################################################################
  # Insert player into the database
  ###################################################################

  def addUser() do
    Accounts.name()
    |>Accounts.checkDataForName()
  end

  ###################################################################
  # End of Inserting players into the database 
  ###################################################################

  ###################################################################
  # Adding match history into the database
  ###################################################################

  # All account ids(CHECK)
  # get all recent match Id(CHECK)
  # 
  def recentMatches do
    Helperfunction.getAccountIdFunction()
    |> Recentmatches.loopToGetMatchId()
    |> Recentmatches.loopMatchId()
  end

  ###################################################################
  # End of match history into the database 
  ###################################################################

end
