import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option
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

  let counts =
    l2
    |> list.map(int.parse)
    |> result.values()
    |> list.fold(dict.new(), fn(acc, x) {
      acc |> dict.upsert(x, fn(x) { x |> option.unwrap(0) |> int.add(1) })
    })

  l1
  |> list.map(int.parse)
  |> result.values()
  |> list.map(fn(x) {
    counts |> dict.get(x) |> result.unwrap(0) |> int.multiply(x)
  })
  |> list.fold(0, int.add)
  |> int.to_string()
  |> io.println()
  |> Ok()
}
