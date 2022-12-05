defmodule KinoAOC do
  @moduledoc false

  def download_puzzle(year, day, session) do
    {:ok, res} =
      Req.get("https://adventofcode.com/#{year}/day/#{day}/input",
        headers: [{"cookie", "session=#{session}"}]
      )

    case res.status do
      200 -> {:ok, res.body}
      _ -> raise "\nStatus: #{inspect(res.status)}\nError: #{inspect(res.body)}"
    end
  end
end
