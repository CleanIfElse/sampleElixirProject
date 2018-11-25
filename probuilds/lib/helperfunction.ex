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



end