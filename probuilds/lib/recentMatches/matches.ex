defmodule Matches do
    @moduledoc """
    Documentation for Probuilds.
    """

    def matchHistoryId(accountId) when is_list(accountId) do
        accountId
        |> Enum.map(fn i -> Helperfunction.getLatestGameId(i) end)
        # |> Enum.map(fn i -> Queries.checkMatchId(i) end)
        |> Enum.map(fn i -> Helperfunction.checkValidJson("https://na1.api.riotgames.com/lol/match/v3/matches/#{i}/?api_key=RGAPI-8808378a-f94b-4a28-b470-33ad502d1b61")  end)
        |> Enum.map(fn i -> Queries.insertMatchHistory(i) end)
    end

    def matchHistoryId(accountId) when is_integer(accountId) do
        Helperfunction.getLatestGameId(accountId)
    end

    def detailsMatchHistory(matchId, accountId) do
      { :ok, response } = Helperfunction.checkValidJson("https://na1.api.riotgames.com/lol/match/v3/timelines/by-match/#{matchId}/?api_key=RGAPI-8808378a-f94b-4a28-b470-33ad502d1b61")
      response
      |> Map.get("frames")
      |> Enum.map(fn i -> skillsLevelUpDetails(i |> Map.get("events")) end)
    end

    def skillsLevelUpDetails(response) do
      Map.get(response, "itemId")

    end
  end
