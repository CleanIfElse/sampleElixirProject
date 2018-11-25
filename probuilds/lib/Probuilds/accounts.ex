defmodule Accounts do
      # This is used to add users

  def getUserInformation(region, name, realName) do
    # This checks if account name exists.
    { :ok, response } = Helperfunction.checkValidJson("https://#{region}.api.riotgames.com/lol/summoner/v3/summoners/by-name/#{name}/?api_key=RGAPI-57f2eee1-693e-42e9-b7a1-f0b34cffd1df")
    {response, region, realName}
  end

  # add into database. Only used with getUserInformation()
  def addAccount({response, region, realName}) do
    Helperfunction.insertAccount(response |> Map.get("id"), realName, response |> Map.get("name"), region)
  end
end
