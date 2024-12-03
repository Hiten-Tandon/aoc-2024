import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import utility.{get_input}

pub fn main() {
  use data <- result.try(get_input(2))

  data
  |> string.split("\n")
  |> list.map(fn(x) {
    x |> string.split(" ") |> list.map(int.parse) |> result.values()
  })
  |> list.filter(fn(x) { x |> list.is_empty() |> bool.negate() })
  |> list.filter(fn(x) {
    x
    |> list.window_by_2()
    |> list.all(fn(x) { [1, 2, 3] |> list.contains(x.0 - x.1) })
    || x
    |> list.window_by_2()
    |> list.all(fn(x) { [1, 2, 3] |> list.contains(x.1 - x.0) })
  })
  |> list.length()
  |> int.to_string()
  |> io.println()
  |> Ok()
}
