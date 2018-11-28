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
        (rlname, ingame, region, accountid) VALUES
        ('#{realName}', '#{ingame}', '#{region}', :id)"
        {:ok, %Xandra.Void{}} = Xandra.execute(conn, statement, %{
          id: {"bigint", id}
          })
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

    def insertMap(map, prikey, type) do
       {:ok, conn} = Helperfunction.connection()
      statement = "UPDATE indivisualstats SET #{type} = :items WHERE id = :prikey"
      {:ok, %Xandra.Void{}} = Xandra.execute(conn, statement, %{
         items: {"map<int, int>", map},
         prikey: {"bigint", prikey},
       })
    end

    def insertMatchHistory(response, conn) do
      response |> Map.get("teams") |> List.first
      gameid = response |> Map.get("gameId")
      win = response |> Map.get("teams") |> List.first |> Map.get("win")
      duration = response |> Map.get("gameDuration")
      blueban = response |> Map.get("teams") |> List.first |> Map.get("bans")
      redban = response |> Map.get("teams") |> List.last |> Map.get("bans")
      # this can be an update feature
      # statement = "INSERT INTO matchhistorys (gameid, blueban, length, redban) VALUES (:id, :blue, :length, :red)"
      #  {:ok, %Xandra.Void{}} = Xandra.execute(conn, statement, %{
      #    id: {"bigint", response |> Map.get("gameId")},
      #    blue: {"map<text, int>", response |> Map.get("teams") |> List.first |> Map.get("bans")},
      #    length: {"int", response |> Map.get("gameDuration")},
      #    red: {"map<text, int>", response |> Map.get("teams") |> List.last |> Map.get("bans")}
      #   })
    end

    def insertPlayerHistory(response) do
        {:ok, response } = response
        {:ok, conn} = Helperfunction.connection()
        insertMatchHistory(response, conn)
        partIdentities = response |> Map.get("participantIdentities")
        partStats = response |> Map.get("participants")
        gameId = response |> Map.get("gameId")
        for x <- 0..9 do
          prikey = "#{gameId}#{Enum.at(partIdentities, x) |> Map.get("player") |> Map.get("accountId")}" |> String.to_integer
          statement = "INSERT INTO indivisualstats (id, accountid, assists, championid, deaths, gold, finalkeystone, kills, level, name, region, finalitems, summoner1, summoner2, matchId, participantId, win, allrunes) VALUES (:prikey, #{Enum.at(partIdentities, x) |> Map.get("player") |> Map.get("accountId")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("assists")}, #{Enum.at(partStats, x) |> Map.get("championId")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("deaths")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("goldEarned")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("perk3Var1")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("kills")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("champLevel")}, '#{Enum.at(partIdentities, x) |> Map.get("player") |> Map.get("summonerName")}', '#{Enum.at(partIdentities, x) |> Map.get("player") |> Map.get("platformId")}', :items, :sum1, :sum2, :match, :partid, :win, :runes)"
          {:ok, %Xandra.Void{}} = Xandra.execute(conn, statement, %{
            prikey: {"bigint", prikey},
            match: {"bigint", gameId},
            partid: {"int", Enum.at(partIdentities, x) |> Map.get("participantId")},
            sum1: {"int", Enum.at(partStats, x) |> Map.get("spell1Id")},
            sum2: {"int", Enum.at(partStats, x) |> Map.get("spell2Id")},
            items: {"list<int>", [Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item0"), Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item1"), Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item2"), Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item3"), Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item4"), Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item5"), Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item6")]},
            win: {"boolean", Enum.at(partStats, x) |> Map.get("stats") |> Map.get("win")},
            runes: {"list<int>", [ Enum.at(partStats, x) |> Map.get("stats") |> Map.get("perk3Var1"), Enum.at(partStats, x) |> Map.get("stats") |> Map.get("perk0"), Enum.at(partStats, x) |> Map.get("stats") |> Map.get("perk1"), Enum.at(partStats, x) |> Map.get("stats") |> Map.get("perk2"), Enum.at(partStats, x) |> Map.get("stats") |> Map.get("perk3"), Enum.at(partStats, x) |> Map.get("stats") |> Map.get("perk4"),Enum.at(partStats, x) |> Map.get("stats") |> Map.get("perk5")]}
          })
          Matches.detailsMatchHistory(gameId, Enum.at(partIdentities, x) |> Map.get("participantId"), prikey)

        end
    end

  end
