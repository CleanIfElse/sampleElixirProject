defmodule Accounts do
      # This is used to add users

  def getUserInformation(region, name, realName) do
    # This checks if account name exists.
    { :ok, response } = Helperfunction.checkValidJson("https://#{region}.api.riotgames.com/lol/summoner/v3/summoners/by-name/#{name}/?api_key=")
    {response, region, realName}
  end

  # add into database. Only used with getUserInformation()
  def addAccount({response, region, realName}) do
    Queries.insertAccount(response |> Map.get("accountId"), realName, response |> Map.get("name"), region)
  end
end
