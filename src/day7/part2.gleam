import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import utility.{get_input}

fn possible(result: Int, acc: Int, operands: List(Int)) -> Bool {
  let head = operands |> list.first

  case head {
    Ok(v) -> {
      possible(result, acc + v, operands |> list.rest |> result.unwrap([]))
      || possible(result, acc * v, operands |> list.rest |> result.unwrap([]))
      || possible(
        result,
        { int.to_string(acc) <> int.to_string(v) }
          |> int.parse
          |> result.unwrap(0),
        operands |> list.rest |> result.unwrap([]),
      )
    }
    Error(_) -> acc == result
  }
}

pub fn main() {
  use input <- result.try(get_input(7))

  input
  |> string.split("\n")
  |> list.map(fn(x) { string.split_once(x, ": ") })
  |> result.values()
  |> list.map(fn(x) {
    #(
      x.0 |> int.parse |> result.unwrap(0),
      x.1
        |> string.split(" ")
        |> list.map(int.parse)
        |> result.values,
    )
  })
  |> list.filter_map(fn(x) {
    case
      possible(
        x.0,
        x.1 |> list.first |> result.unwrap(0),
        x.1 |> list.rest |> result.unwrap([]),
      )
    {
      True -> Ok(x.0)
      False -> Error(Nil)
    }
  })
  |> list.fold(0, int.add)
  |> int.to_string
  |> io.println
  |> Ok()
}
