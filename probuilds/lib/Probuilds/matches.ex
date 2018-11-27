defmodule Matches do
    @moduledoc """
    Documentation for Probuilds.
    """

    #
    def matchHistoryId(accountId) when is_list(accountId) do
        accountId
        |> Enum.map(fn i -> Helperfunction.getLatestGameId(i) end)
        # |> Enum.map(fn i -> Queries.checkMatchId(i) end)
        |> Enum.map(fn i -> Helperfunction.checkValidJson("https://na1.api.riotgames.com/lol/match/v3/matches/#{i}/?api_key=")  end)
        |> Enum.map(fn i -> Queries.insertMatchHistory(i) end)
    end

    #
    def matchHistoryId(accountId) when is_integer(accountId) do
        Helperfunction.getLatestGameId(accountId)
    end

    # Match History Details
    def detailsMatchHistory(matchId, accountId) do
      { :ok, response } = Helperfunction.checkValidJson("https://na1.api.riotgames.com/lol/match/v3/timelines/by-match/#{matchId}/?api_key=")
      response
      |> Map.get("frames")
      |> Enum.map(fn i -> skillsLevelUpDetails(i) end)
    end

    defp skillsLevelUpDetails(response) do
      resting = []
      for rest <- response |> Map.get("events") do
        rest
        # Enum.map(rest, fn {key, value} -> if key == 'type' and value == 'value' do key end  end)
          # Map.take(rest , ["type", "itemId", "participantId", "timestamp"])
      end
    end
  end
