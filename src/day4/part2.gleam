import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import utility.{get_input}

pub fn main() {
  use data <- result.try(get_input(4))
  data
  |> string.split("\n")
  |> list.map(string.to_graphemes)
  |> list.window(3)
  |> list.map(fn(win) {
    win
    |> list.transpose()
    |> list.window(3)
    |> list.count(fn(sq) {
      case sq {
        [["S", _, "M"], [_, "A", _], ["S", _, "M"]]
        | [["M", _, "S"], [_, "A", _], ["M", _, "S"]]
        | [["M", _, "M"], [_, "A", _], ["S", _, "S"]]
        | [["S", _, "S"], [_, "A", _], ["M", _, "M"]] -> True
        _ -> False
      }
    })
  })
  |> list.fold(0, int.add)
  |> int.to_string()
  |> io.println()
  |> Ok()
}
