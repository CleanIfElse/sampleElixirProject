defmodule Helperfunction do

  # connection to database
  def connection() do
    {:ok, conn} = Xandra.start_link(nodes: ["127.0.0.1:9042"])
    case {:ok, conn} do
      {:ok, conn} ->
        Xandra.execute!(conn, "USE probuilds")
        {:ok, conn}
      {:error} ->
        {:error, "Something is wrong with your connection."}
    end
  end

  # This function will get all of the account id
  def getAccountId() do
    {:ok, page} = Queries.allAccountId()
    page
    |> Enum.to_list()
    |> Enum.map(fn(x) -> x["accountid"] end) 
  end

  # check if json is valid
  def checkValidJson(link) do
    case HTTPoison.get(link) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        { :ok, response } = Poison.decode(body)
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
      end
  end

  # This function will get the latest game Id
  def getLatestGameId(accountId) do
    accountId = accountId |> to_string()
    {:ok, response} = checkValidJson("https://na1.api.riotgames.com/lol/match/v3/matchlists/by-account/#{accountId}/?api_key=RGAPI-57f2eee1-693e-42e9-b7a1-f0b34cffd1df")
    response |> Map.get("matches") |> List.first() |> Map.get("gameId")
  end

  # This function will insert indivisual game stats
  def insertIndiStats() do

  end



end
