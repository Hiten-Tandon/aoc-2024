import gleam/int
import gleam/io
import gleam/iterator
import gleam/list
import gleam/result
import gleam/set.{type Set}
import gleam/string
import glearray.{type Array}
import utility.{get_input}

pub fn get_all_trails(
  grid: Array(Array(Int)),
  row: Int,
  col: Int,
  should_be: Int,
) -> Int {
  case
    grid |> glearray.get(row) |> result.then(fn(x) { x |> glearray.get(col) })
  {
    Ok(x) if x == should_be && should_be > 0 -> {
      get_all_trails(grid, row, col + 1, should_be - 1)
      + get_all_trails(grid, row, col - 1, should_be - 1)
      + get_all_trails(grid, row + 1, col, should_be - 1)
      + get_all_trails(grid, row - 1, col, should_be - 1)
    }
    Ok(0) if should_be == 0 -> 1
    _ -> 0
  }
}

pub fn main() {
  use data <- result.try(get_input(10))
  let grid =
    data
    |> string.trim
    |> string.split("\n")
    |> list.map(string.to_graphemes)
    |> list.map(fn(x) { x |> list.map(int.parse) |> result.values })
    |> list.map(glearray.from_list)
    |> glearray.from_list
  grid
  |> glearray.iterate
  |> iterator.index
  |> iterator.map(fn(x: #(Array(Int), Int)) {
    let #(row, ri) = x
    row
    |> glearray.iterate
    |> iterator.index
    |> iterator.map(fn(x) {
      let #(ele, ci) = x
      get_all_trails(grid, ri, ci, 9)
    })
    |> iterator.fold(0, int.add)
  })
  |> iterator.fold(0, int.add)
  |> int.to_string
  |> io.println
  |> Ok
}
