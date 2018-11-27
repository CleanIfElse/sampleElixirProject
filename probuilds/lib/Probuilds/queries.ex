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
          statement = "INSERT INTO testStat (id, accountid, assists, championid, deaths, gold, keystone, kills, level, name, region, items, summoners, matchId) VALUES (:id, :accountId, :assist, :champId, :deaths, :gold, :keystone, :kills, :level, :name, :region, :items, :summoners, :match)"
          {:ok, %Xandra.Void{}} = Xandra.execute(conn, statement, %{
            id: {"bigint", :os.system_time(:micro_seconds)},
            accountId: {"int", Enum.at(partIdentities, x) |> Map.get("player") |> Map.get("accountId")},
            assist: {"int", Enum.at(partStats, x) |> Map.get("stats") |> Map.get("assists")},
            champId: {"int", Enum.at(partStats, x) |> Map.get("championId")},
            deaths: {"int", Enum.at(partStats, x) |> Map.get("stats") |> Map.get("deaths")},
            gold: {"int", Enum.at(partStats, x) |> Map.get("stats") |> Map.get("goldEarned")},
            keystone: {"int", Enum.at(partStats, x) |> Map.get("stats") |> Map.get("perk3Var1")},
            kills: {"int", Enum.at(partStats, x) |> Map.get("stats") |> Map.get("kills")},
            level: {"int", Enum.at(partStats, x) |> Map.get("stats") |> Map.get("champLevel")},
            name: {"text", Enum.at(partIdentities, x) |> Map.get("player") |> Map.get("summonerName")},
            region: {"text", Enum.at(partIdentities, x) |> Map.get("player") |> Map.get("platformId")},
            items: {"list<int>", [Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item0"), Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item1"), Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item2"), Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item3"), Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item4"), Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item5"), Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item6")]},
            summoners: {"list<int>", [Enum.at(partStats, x) |> Map.get("spell1Id"), Enum.at(partStats, x) |> Map.get("spell2Id")]},
            match: {"bigint", gameId}
          })
          Matches.detailsMatchHistory(gameId, {Enum.at(partIdentities, x) |> Map.get("player") |> Map.get("accountId")})

        end
    end

  end
