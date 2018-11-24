defmodule Accounts do
      # This is used to add users
  def name do
    inGame = IO.gets("What is your in game name? ")
    region = IO.gets("What is your region? ")
    inGame = inGame |> String.trim()
    region = region |> String.trim()
    {inGame, region}
  end

  # check data if name is available
  def checkDataForName({inGame, region}) do
    {ok, conn} = Helperfunction.connection()
    statement = "SELECT accountid FROM accountInformation WHERE ingame = '#{inGame}' ALLOW FILTERING"
    {:ok, %Xandra.Page{} = page} = Xandra.execute(conn, statement, _params = [])
    if page |> Map.get("rows") == nil do
      ({inGame, region})
    else
      "#{inGame} is inside"
    end
  end

  def get_body(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        {:ok, response} = Poison.decode(body)
        {:ok, response}

      {:ok, %{status_code: 403}} ->
        {:error, "Forbidden. Check your API Key."}

      {:ok, %{status_code: 404}} ->
        {:error, "Not found"}

      {:ok, %{status_code: 415}} ->
        {:error, "Unsupported media type. Check the Content-Type header."}

      {:ok, %{status_code: 429}} ->
        {:error, "Rate limit exceeded."}

      {:error, reason} ->
        {:error, reason}
    end
  end

  # add into database
  def addAccount({id, inGame, region}) do
    {:ok, conn} = Xandra.start_link(nodes: ["127.0.0.1:9042"])
    Xandra.execute!(conn, "USE probuilds")
    statement = "INSERT INTO accountInformation (id, rlname, ingame, region, accountid, championId) VALUES (10, 'Niral Patel', '#{inGame}', '#{region}', #{id})"
    {:ok, %Xandra.Void{}} = Xandra.execute(conn, statement, _params = [])
  end
end