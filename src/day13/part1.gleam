import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import utility.{get_input}

pub fn main() {
  use data <- result.try(get_input(13))
  data
  |> string.split("\n\n")
  |> list.map(fn(x) {
    let assert [#(a1, b1), #(a2, b2), #(c1, c2)] =
      string.split(x, "\n")
      |> list.map(fn(y) { string.split_once(y, ": ") })
      |> result.values
      |> list.map(fn(x) {
        x.1
        |> string.replace("X", "")
        |> string.replace("Y", "")
        |> string.replace("+", "")
        |> string.replace("=", "")
        |> string.trim
        |> string.split_once(", ")
      })
      |> result.values
      |> list.map(fn(x) {
        #(result.unwrap(int.parse(x.0), 0), result.unwrap(int.parse(x.1), 0))
      })

    let count1 = { c1 * b2 - c2 * a2 } / { a1 * b2 - a2 * b1 }
    let count2 = { c1 * b1 - c2 * a1 } / { a2 * b1 - a1 * b2 }
    case #(a1 * count1 + a2 * count2, b1 * count1 + b2 * count2) == #(c1, c2) {
      True -> 3 * count1 + count2
      False -> 0
    }
  })
  |> list.fold(0, int.add)
  |> int.to_string
  |> io.println
  |> Ok
}
