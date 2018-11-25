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
        prepared = Xandra.prepare!(conn, "SELECT * FROM matchHistorys WHERE id = ?")
        {:ok, _page} = Xandra.execute(conn, prepared, [_id = matchId])
    end
  
  end
  