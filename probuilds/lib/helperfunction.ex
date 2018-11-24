defmodule Helperfunction do
  
  #This function is used to grab all account ids
  def getAccountIdFunction do
    connection()
    |> getAccountId()
  end

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
  def getAccountId({:ok, conn}) do
    statement = "SELECT accountid FROM accountInformation"
    {:ok, %Xandra.Page{} = page} = Xandra.execute(conn, statement, _params = [])
    accountIdName = Enum.to_list(page)
    Enum.map(accountIdName, fn(x) -> x["accountid"] end) 
  end



end