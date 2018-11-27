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
    # iex(14)> Matches.detailsMatchHistory(2876054290, 233564428, 1)
    def detailsMatchHistory(matchId, accountId, partid) do
      { :ok, response } = Helperfunction.checkValidJson("https://na1.api.riotgames.com/lol/match/v3/timelines/by-match/#{matchId}/?api_key=")
      response |> Map.get("frames")
      |> Enum.map(fn i -> Enum.filter(i |> Map.get("events"), fn map -> map["type"] == "ITEM_PURCHASED" and map["participantId"] == partid end) end)
      |> skillsandItemsDetails()
      |> printMap()
    end

    defp printMap(mapping) do
      '#{mapping}mapping'
    end

     defp skillsandItemsDetails(response) do
       map = %{a: 1,}
       Enum.each response, fn rest ->
         if rest != [] do
           Enum.each rest, fn res ->
               # Map.put(map, res |> Map.get("timestamp"), 2)

               time = IO.inspect res |> Map.get("timestamp")
               itemId = IO.inspect res |> Map.get("itemId")
               Map.put(map, time, itemId)
           end
         end
         {map}
       end
     end
  end
