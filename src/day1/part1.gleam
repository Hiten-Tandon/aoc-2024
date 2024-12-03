import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import utility.{get_input}

pub fn main() {
  use data <- result.try(get_input(1))

  let #(l1, l2) =
    data
    |> string.split("\n")
    |> list.map(fn(l) { l |> string.split_once("   ") })
    |> result.values()
    |> list.unzip()

  list.map2(
    l1 |> list.map(int.parse) |> result.values() |> list.sort(int.compare),
    l2 |> list.map(int.parse) |> result.values() |> list.sort(int.compare),
    fn(x, y) { x - y |> int.absolute_value() },
  )
  |> list.fold(0, int.add)
  |> int.to_string()
  |> io.println()
  |> Ok()
}
