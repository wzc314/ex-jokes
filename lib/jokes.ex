defmodule Jokes do
  @moduledoc """
  Documentation for Jokes.
  """

  @url "http://www.qiushibaike.com/text/page/"

  @doc """
  main function.
  """
  def main(argv) do
    argv
    |> parse_args
    |> run
  end

  def parse_args(argv) do
    {options, _, _} = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    case options[:help] do
      true -> :help
      _ -> :ok
    end
  end

  def run(:help) do
    IO.puts """
    Just run the binary file: ./jokes
    """
    System.halt(0)
  end

  def run(:ok) do
    get_jokes_recursively()
  end

  @doc """
  Keep getting jokes by recursion.
  """
  def get_jokes_recursively(page \\ 1) do
    IO.puts "---------- Downloading jokes from qiushibaike ----------"
    get_jokes(page)
    get_jokes_recursively(page+1)
  end

  def get_jokes(page) do
    HTTPoison.get!(@url<>Integer.to_string(page), [], hackney: [follow_redirect: true])
    |> Map.get(:body)
    |> Floki.find("div a div.content span") # find the joke item in each span element with CSS selector
    |> Enum.map(&elem(&1,2)) 
    |> Enum.map(&format_joke_item/1)
    |> Enum.each(&show_joke/1)
  end

  @doc """
  Format each joke item (the tuples in items stand for carrage return).
  """
  def format_joke_item(item) do
    Enum.reduce(item, fn x,acc when is_tuple(x) -> acc<>"\n"
                         x,acc                  -> acc<>x end)
  end

  def show_joke(joke_item) do
    IO.puts joke_item
    IO.puts "---------- Press <Enter> to show next joke, and <Ctrl-C> twice to exit ----------"
    IO.read :stdio, :line
  end

end
