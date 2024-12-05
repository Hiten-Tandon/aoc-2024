import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import utility.{get_input}

pub fn main() {
  use data <- result.try(get_input(5))

  let assert Ok(#(ordering, updates)) =
    data
    |> string.split_once("\n\n")

  let ordering =
    ordering
    |> string.split("\n")
    |> list.map(fn(x) { x |> string.split_once("|") })
    |> result.values
    |> list.map(fn(x) {
      use a <- result.try(int.parse(x.0))
      use b <- result.try(int.parse(x.1))
      #(a, b) |> Ok
    })
    |> result.values()

  let updates =
    updates
    |> string.split("\n")
    |> list.map(fn(x) {
      x |> string.split(",") |> list.map(int.parse) |> result.values
    })

  let idxs =
    updates
    |> list.map(fn(ls) { list.index_fold(ls, dict.new(), dict.insert) })

  updates
  |> list.zip(idxs)
  |> list.filter(fn(x) {
    let #(_, idxs) = x
    ordering
    |> list.filter(fn(x) { dict.has_key(idxs, x.0) && dict.has_key(idxs, x.1) })
    |> list.all(fn(order) {
      let assert Ok(a) = dict.get(idxs, order.0)
      let assert Ok(b) = dict.get(idxs, order.1)
      a < b
    })
  })
  |> list.map(fn(x) {
    x.0
    |> list.drop({
      x.0 |> list.length() |> int.floor_divide(2) |> result.unwrap(0)
    })
    |> list.first()
    |> result.unwrap(0)
  })
  |> list.fold(0, int.add)
  |> int.to_string
  |> io.println
  |> Ok()
}
