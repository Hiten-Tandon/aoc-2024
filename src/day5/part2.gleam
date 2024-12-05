import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/order
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
  |> list.filter_map(fn(x) {
    let #(ls, idxs) = x
    let sub_ordering =
      list.filter(ordering, fn(x) {
        dict.has_key(idxs, x.0) && dict.has_key(idxs, x.1)
      })
    case
      sub_ordering
      |> list.any(fn(order) {
        let assert Ok(a) = dict.get(idxs, order.0)
        let assert Ok(b) = dict.get(idxs, order.1)
        a >= b
      })
    {
      False -> Error(Nil)
      True -> Ok(#(ls, sub_ordering))
    }
  })
  |> list.map(fn(x) {
    let #(ls, sub_ordering) = x
    ls
    |> list.sort(fn(a, b) {
      case
        sub_ordering |> list.contains(#(b, a)),
        sub_ordering
        |> list.contains(#(a, b))
      {
        False, False -> order.Eq
        False, True -> order.Lt
        True, _ -> order.Gt
      }
    })
    |> list.drop({ ls |> list.length |> int.bitwise_shift_right(1) })
    |> list.first()
    |> result.unwrap(0)
  })
  |> list.fold(0, int.add)
  |> int.to_string
  |> io.println
  |> Ok()
}
