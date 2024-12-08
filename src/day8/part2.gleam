import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/set
import gleam/string
import gleam/yielder
import utility.{get_input}

pub fn main() {
  use data <- result.try(get_input(8))
  let grid =
    data
    |> string.trim
    |> string.split("\n")
    |> list.map(string.to_graphemes)
  let rc = list.length(grid)
  let cc = list.length(grid |> list.first |> result.unwrap([]))
  grid
  |> list.index_fold(
    dict.new(),
    fn(acc: dict.Dict(String, List(#(Int, Int))), row: List(String), ri: Int) {
      use emitters, ele, ci <- list.index_fold(row, acc)
      case ele {
        "." -> emitters
        c -> {
          emitters
          |> dict.upsert(c, fn(x: Option(List(#(Int, Int)))) {
            case x {
              None -> [#(ri, ci)]
              Some(ls) -> {
                [#(ri, ci), ..ls]
              }
            }
          })
        }
      }
    },
  )
  |> dict.values
  |> list.map(fn(positions: List(#(Int, Int))) {
    positions
    |> list.combination_pairs
    |> list.flat_map(fn(point_pair: #(#(Int, Int), #(Int, Int))) -> List(
      #(Int, Int),
    ) {
      let #(#(r1, c1), #(r2, c2)) = point_pair
      let dr = r2 - r1
      let dc = c2 - c1
      yielder.iterate(#(r1, c1), fn(x) { #(x.0 - dr, x.1 - dc) })
      |> yielder.take_while(fn(x: #(Int, Int)) -> Bool {
        0 <= x.0 && x.0 < rc && 0 <= x.1 && x.1 < cc
      })
      |> yielder.append(
        yielder.iterate(#(r1, c1), fn(x) { #(x.0 + dr, x.1 + dc) })
        |> yielder.take_while(fn(x: #(Int, Int)) -> Bool {
          0 <= x.0 && x.0 < rc && 0 <= x.1 && x.1 < cc
        }),
      )
      |> yielder.to_list
    })
    |> set.from_list
  })
  |> list.fold(set.new(), set.union)
  |> set.size
  |> int.to_string
  |> io.println
  |> Ok
}
