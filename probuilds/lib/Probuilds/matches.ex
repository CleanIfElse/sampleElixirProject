defmodule Matches do
    @moduledoc """
    Documentation for Probuilds.
    """

    # if it is list
    def matchHistoryId(accountId) when is_list(accountId) do
        accountId
        |> Enum.map(fn i -> Helperfunction.getLatestGameId(i) end)
        # |> Enum.map(fn i -> Queries.checkMatchId(i) end)
        |> Enum.map(fn i -> Helperfunction.checkValidJson("https://na1.api.riotgames.com/lol/match/v3/matches/#{i}/?api_key=")  end)
        |> Enum.map(fn i -> Queries.insertPlayerHistory(i) end)
    end

    # if it is integer
    def matchHistoryId(accountId) when is_integer(accountId) do
        Helperfunction.getLatestGameId(accountId)
    end

    # Match History Details
    # iex(14)> Matches.detailsMatchHistory(2876054290, 233564428, 1)
    def detailsMatchHistory(matchId, partid, prikey) do
      { :ok, response } = Helperfunction.checkValidJson("https://na1.api.riotgames.com/lol/match/v3/timelines/by-match/#{matchId}/?api_key=")
      response = response |> Map.get("frames")
      itemsDetails(response, prikey, partid)
      skillsDetails(response, prikey, partid)
    end

    defp skillsDetails(response, prikey, partid) do
      map = %{}
      Enum.map(response, fn i -> Enum.filter(i |> Map.get("events"), fn map -> map["type"] == "SKILL_LEVEL_UP" and map["participantId"] == partid end) end)
      |> Enum.reject(&Enum.empty?/1)
      |> List.flatten()
      |> Enum.map(fn i -> Map.put(map, i |> Map.get("timestamp"), i |> Map.get("skillSlot")) end)
      |> Enum.reduce(fn x, y ->
         Map.merge(x, y, fn _k, v1, v2 -> v2 ++ v1 end)
       end)
      |> Queries.insertMap(prikey, 'skills')
    end

     defp itemsDetails(response, prikey, partid) do
       map = %{}
       Enum.map(response, fn i -> Enum.filter(i |> Map.get("events"), fn map -> map["type"] == "ITEM_PURCHASED" and map["participantId"] == partid end) end)
       |> Enum.reject(&Enum.empty?/1)
       |> List.flatten()
       |> Enum.map(fn i -> Map.put(map, i |> Map.get("timestamp"), i |> Map.get("itemId")) end)
       |> Enum.reduce(fn x, y ->
          Map.merge(x, y, fn _k, v1, v2 -> v2 ++ v1 end)
        end)
       |> Queries.insertMap(prikey, 'allitems')
     end
  end
