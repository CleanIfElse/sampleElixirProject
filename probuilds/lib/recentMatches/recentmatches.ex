defmodule RecentHero do
    def loopToGetMatchId(accountIdName) when is_list(accountIdName) do
        accountIdName
        |> Enum.map(fn i -> getMatchId(i) end)
  end

    def loopMatchId(matchId) when is_list(matchId) do
        matchId
        |> Enum.map(fn i -> getMatchInformation(i) end)
    end

    def getMatchId(i) do
        i |> Integer.to_string()
        response = HTTPotion.get "https://na1.api.riotgames.com/lol/match/v3/matchlists/by-account/#{i}/?api_key=RGAPI-90f0a3d5-4324-4c5f-9ace-19857f9c00f2"
        response.body |> Poison.decode! |> Map.get("matches") |> List.first() |> Map.get("gameId")
    end

    def getMatchInformation(i) do
        # You can put this into a new function and check the response code
        ########################################################
        i |> Integer.to_string
        response = HTTPotion.get "https://na1.api.riotgames.com/lol/match/v3/matches/#{i}/?api_key=RGAPI-90f0a3d5-4324-4c5f-9ace-19857f9c00f2"
        response = response.body |> Poison.decode!
        ##########################################################
        gameId = response |> Map.get("gameId")
        partIdentities = response |> Map.get("participantIdentities")
        partStats = response |> Map.get("participants")
        ###########################################################
        {:ok, conn} = Xandra.start_link(nodes: ["127.0.0.1:9042"])
        Xandra.execute!(conn, "USE probuilds")
        for x <- 0..9 do
            # This is where I insert all the data
            # Some are in a list while players information are stored in the players table
            # Some of the values show up as null which is confusing
            statement = "INSERT INTO playersTrialStats (id, accountid, assists, championid, deaths, gold, keystone, kills, level, name, region, items, summoners) VALUES (#{:os.system_time(:micro_seconds)}, #{Enum.at(partIdentities, x) |> Map.get("player") |> Map.get("accountId")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("assists")}, #{Enum.at(partStats, x) |> Map.get("championId")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("deaths")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("goldEarned")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("perk3Var1")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("kills")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("champLevel")}, '#{Enum.at(partIdentities, x) |> Map.get("player") |> Map.get("summonerName")}', '#{Enum.at(partIdentities, x) |> Map.get("player") |> Map.get("platformId")}', [#{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item0")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item1")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item2")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item3")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item4")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item5")}, #{Enum.at(partStats, x) |> Map.get("stats") |> Map.get("item6")}], [#{Enum.at(partStats, x) |> Map.get("spell1Id")}, #{Enum.at(partStats, x) |> Map.get("spell2Id")}])"

            {:ok, %Xandra.Void{}} = Xandra.execute(conn, statement, _params = [])
            ###########################################################
        end
    end
end
