defmodule Queries do
    @moduledoc """
    Documentation for Queries.
    """
    # This function grabs all account ids
    def allAccountId() do
        {:ok, conn} = Helperfunction.connection()
        statement = "SELECT accountid FROM accountInformation"
        {:ok, page} = Xandra.execute(conn, statement, _params = [])
    end

    # this function inserts account information
    def insertAccount(id, realName, ingame, region) do
        {:ok, conn} = Helperfunction.connection()
        statement = "INSERT INTO accountinformation
        (id, rlname, ingame, region, accountid) VALUES
        (#{id}, '#{realName}', '#{ingame}', '#{region}', #{id})"
        {:ok, %Xandra.Void{}} = Xandra.execute(conn, statement, _params = [])
      end

      # Check if match id exists
      def checkMatchId(matchId) do
        :matchId = matchId
        {:ok, conn} = Helperfunction.connection()
        prepared = Xandra.prepare!(conn, "SELECT * FROM matchHistorys WHERE id = :id")
        {:ok, _page} = Xandra.execute(conn, prepared, %{
          id: {"int", matchId}
        })
    end

    # def updateMatchDetails(matchId, accountId) do
    #
    #   response |> Map.get("frames") |> List.first()
    #
    # end

    def insertMatchHistory(response) do
        {:ok, response } = response
        {:ok, conn} = Helperfunction.connection()
        partIdentities = response |> Map.get("participantIdentities")
        partStats = response |> Map.get("participants")
        gameId = response |> Map.get("gameId")
        for x <- 0..9 do
          statement = "INSERT INTO testStat (id, accountid, assists, championid, deaths, gold, keystone, kills, level, name, region, items, summoners, matchId) VALUES (#{:os.system_time(:micro_seconds)}, #{Enum.at(partIdentities, x) |> Map.get("player") |> Map.get("accountId")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("assists")}, #{Enum.at(partStats, x) |> Map.get("championId")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("deaths")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("goldEarned")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("perk3Var1")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("kills")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("champLevel")}, '#{Enum.at(partIdentities, x) |> Map.get("player") |> Map.get("summonerName")}', '#{Enum.at(partIdentities, x) |> Map.get("player") |> Map.get("platformId")}', [#{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item0")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item1")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item2")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item3")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item4")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item5")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item6")}], [#{Enum.at(partStats, x) |> Map.get("spell1Id")}, #{Enum.at(partStats, x) |> Map.get("spell2Id")}], :match)"
          {:ok, %Xandra.Void{}} = Xandra.execute(conn, statement, %{
            match: {"bigint", gameId}
          })
          Matches.detailsMatchHistory(gameId, {Enum.at(partIdentities, x) |> Map.get("player") |> Map.get("accountId")})

        end
    end

  end
