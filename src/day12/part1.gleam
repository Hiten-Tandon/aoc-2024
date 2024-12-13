import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/set.{type Set}
import gleam/string
import gleam/yielder
import glearray.{type Array}
import utility.{get_input}

fn flood_fill(
  grid: Array(Array(String)),
  target: String,
  vis: Set(#(Int, Int)),
  ri: Int,
  ci: Int,
) -> #(Set(#(Int, Int)), Int, Int) {
  let ele =
    grid |> glearray.get(ri) |> result.then(fn(x) { glearray.get(x, ci) })
  case ele {
    Error(_) -> #(vis, 0, 1)
    Ok(x) if x != target -> #(vis, 0, 1)
    Ok(_) ->
      case vis |> set.contains(#(ri, ci)) {
        False ->
          list.fold(
            [#(0, 1), #(0, -1), #(1, 0), #(-1, 0)],
            #(vis |> set.insert(#(ri, ci)), 1, 0),
            fn(acc: #(Set(#(Int, Int)), Int, Int), deltas: #(Int, Int)) {
              let #(vis, t1, t2) = acc
              let #(vis, t3, t4) =
                flood_fill(grid, target, vis, ri + deltas.0, ci + deltas.1)
              #(vis, t1 + t3, t2 + t4)
            },
          )
        True -> #(vis, 0, 0)
      }
  }
}

pub fn main() {
  use data <- result.try(get_input(12))

  let grid =
    data
    |> string.trim
    |> string.split("\n")
    |> list.map(string.to_graphemes)
    |> list.map(glearray.from_list)
    |> glearray.from_list

  let rc = grid |> glearray.length
  let cc =
    grid |> glearray.get(0) |> result.map(glearray.length) |> result.unwrap(0)

  {
    use #(vis, res), ri <- yielder.fold(yielder.range(0, rc - 1), #(
      set.new(),
      0,
    ))
    use #(vis, res), ci <- yielder.fold(yielder.range(0, cc - 1), #(vis, res))

    let ele =
      grid
      |> glearray.get(ri)
      |> result.then(fn(x) { glearray.get(x, ci) })
      |> result.unwrap("")
    let #(vis, a, p) = flood_fill(grid, ele, vis, ri, ci)
    #(vis, res + p * a)
  }.1
  |> int.to_string
  |> io.println
  |> Ok
}
