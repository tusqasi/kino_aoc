defmodule KinoAOC do
  defstruct input_string: "", title: ""

  @moduledoc """

  A helper for Advent of Code (a smart cell) for Elixir [Livebook](https://github.com/livebook-dev/livebook) using [Kino](https://github.com/livebook-dev/kino).

  ## Installation

  To bring KinoAOC to Livebook all you need to do is `Mix.install/2`:

      Mix.install([
        {:kino_aoc, "~> 0.1"}
      ])

  `force: true` does not cache data and forces the module to be downloaded,
  without this, you must manually clear the cache to update and get the latest
  package changes.

  ## Usage

  You only need add the smart cell `Advent of Code Helper` and select the `YEAR`,
  `DAY`, set the `SESSION` and the output `ASSIGN TO`.

  In `SESSION` you can configure a `secret` or set a `string` directly.
  The session id is a cookie which is set when you login to AoC. You can
  find it with your browser inspector.

  > **Warning:**
  > The session string mode saves the content directly in the notebook.
  > Be careful to share it.
  """

  def download_puzzle(year, day, session) do
    {:ok, res} =
      Req.get("http://127.0.0.1:5000/#{year}/day/#{day}/input",
        headers: [{"cookie", "session=#{session}"}]
      )

    {:ok, question} = Req.get("https://adventofcode.com/#{year}/day/#{day}")

    case {question.status, res.status }do
      {200, 200} ->
        input_string  = String.slice(res.body, 0..-2)
        {:ok, document} = Floki.parse_document(question.body)

        title =
          document
          |> Floki.find("article h2")
          |> Floki.text()
          |> String.replace("-", "")
          |> String.trim()
          |> IO.inspect()
          {:ok, %KinoAOC{input_string: input_string, title: title}}

      _ -> raise "\nStatus: #{inspect(res.status)}\nError: #{inspect(String.trim(res.body))}"
    end
  end
end
