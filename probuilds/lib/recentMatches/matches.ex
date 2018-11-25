defmodule Matches do
    @moduledoc """
    Documentation for Probuilds.
    """

    def matchHistoryId(accountId) when is_list(accountId) do
        accountId
        |> Enum.map(fn i -> Helperfunction.getLatestGameId(i) end)
        # |> Enum.map(fn i -> Queries.checkMatchId(i) end)
        |> Enum.map(fn i -> Helperfunction.checkValidJson("https://na1.api.riotgames.com/lol/match/v3/matches/#{i}/?api_key=RGAPI-57f2eee1-693e-42e9-b7a1-f0b34cffd1df")  end)
        |> Enum.map(fn i -> Queries.insertMatchHistory(i) end)
    end

    def matchHistoryId(accountId) when is_integer(accountId) do
        Helperfunction.getLatestGameId(accountId)
    end
  end
