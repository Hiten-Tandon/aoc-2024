import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/yielder
import glearray.{type Array}
import utility.{get_input}

pub type Alpha {
  X
  M
  A
  S
}

pub fn count_xmas(
  grid: Array(Array(Alpha)),
  x: Int,
  y: Int,
  dx: Int,
  dy: Int,
  pos: Int,
) -> Int {
  case
    grid
    |> glearray.get(x)
    |> result.then(fn(row) { glearray.get(row, y) }),
    pos
  {
    Ok(X), 0 | Ok(M), 1 | Ok(A), 2 ->
      count_xmas(grid, x + dx, y + dy, dx, dy, pos + 1)
    Ok(S), 3 -> 1
    _, _ -> 0
  }
}

pub fn main() {
  use data <- result.try(get_input(4))
  let grid =
    data
    |> string.split("\n")
    |> list.map(string.to_graphemes)
    |> list.map(fn(ls) {
      ls
      |> list.map(fn(x) {
        case x {
          "X" -> X
          "M" -> M
          "A" -> A
          "S" -> S
          _ -> panic
        }
      })
    })
    |> list.map(glearray.from_list)
    |> glearray.from_list()
  yielder.range(0, glearray.length(grid) - 1)
  |> yielder.map(fn(x) {
    yielder.range(
      0,
      grid
        |> glearray.get(x)
        |> result.map(glearray.length)
        |> result.unwrap(1)
        |> int.subtract(1),
    )
    |> yielder.map(fn(y) {
      [
        #(-1, 0),
        #(1, 0),
        #(0, -1),
        #(0, 1),
        #(-1, -1),
        #(-1, 1),
        #(1, -1),
        #(1, 1),
      ]
      |> list.map(fn(d) { count_xmas(grid, x, y, d.0, d.1, 0) })
      |> list.fold(0, int.add)
    })
    |> yielder.fold(0, int.add)
  })
  |> yielder.fold(0, int.add)
  |> int.to_string()
  |> io.println()
  |> Ok()
}
