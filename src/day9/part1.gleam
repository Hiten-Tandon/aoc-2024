import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import glearray
import utility.{get_input}

type Block {
  File(filename: Int)
  Empty
}

fn create_checksum(mem_map: glearray.Array(Block), left: Int, right: Int) -> Int {
  case right < left {
    True -> 0
    False ->
      case glearray.get(mem_map, left), glearray.get(mem_map, right) {
        Ok(File(f)), _ -> left * f + create_checksum(mem_map, left + 1, right)
        Ok(Empty), Ok(File(f)) ->
          left * f + create_checksum(mem_map, left + 1, right - 1)
        Ok(Empty), Ok(Empty) -> create_checksum(mem_map, left, right - 1)
        _, _ -> 0
      }
  }
}

pub fn main() {
  use data <- result.try(get_input(9))
  let mem_map =
    data
    |> string.trim
    |> string.to_graphemes
    |> list.map(int.parse)
    |> result.values
    |> list.index_map(fn(x, i) {
      case i % 2 {
        0 ->
          list.repeat(i |> int.floor_divide(2) |> result.unwrap(0) |> File, x)
        1 -> list.repeat(Empty, x)
        _ -> panic as "How did we get here?"
      }
    })
    |> list.flatten
    |> glearray.from_list
  let right = { mem_map |> glearray.length } - 1
  create_checksum(mem_map, 0, right)
  |> int.to_string
  |> io.println
  |> Ok
}
