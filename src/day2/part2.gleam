import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/yielder
import utility.{get_input}

pub fn main() {
  use data <- result.try(get_input(2))

  data
  |> string.split("\n")
  |> list.map(fn(x) {
    x |> string.split(" ") |> list.map(int.parse) |> result.values()
  })
  |> list.filter(fn(x) { x |> list.is_empty() |> bool.negate() })
  |> list.map(fn(x) {
    yielder.range(0, x |> list.length() |> int.subtract(1))
    |> yielder.map(fn(i) {
      x
      |> list.index_map(fn(x, y) { #(y, x) })
      |> list.filter(fn(x) { x.0 != i })
      |> list.map(fn(x) { x.1 })
    })
  })
  |> list.filter(fn(x) {
    x
    |> yielder.any(fn(x) {
      x
      |> list.window_by_2()
      |> list.all(fn(x) { [1, 2, 3] |> list.contains(x.0 - x.1) })
      || x
      |> list.window_by_2()
      |> list.all(fn(x) { [1, 2, 3] |> list.contains(x.1 - x.0) })
    })
  })
  |> list.length()
  |> int.to_string()
  |> io.println()
  |> Ok()
}
