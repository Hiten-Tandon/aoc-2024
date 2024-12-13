import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/set.{type Set}
import gleam/string
import gleam/yielder
import glearray.{type Array}
import utility.{get_input}

fn vertex_count(grid: Array(Array(String)), ri: Int, ci: Int) -> Int {
  let subgrid =
    [
      #(ri - 1, ci - 1),
      #(ri - 1, ci),
      #(ri - 1, ci + 1),
      #(ri, ci - 1),
      #(ri, ci),
      #(ri, ci + 1),
      #(ri + 1, ci - 1),
      #(ri + 1, ci),
      #(ri + 1, ci + 1),
    ]
    |> list.map(fn(x) {
      grid |> glearray.get(x.0) |> result.then(fn(y) { glearray.get(y, x.1) })
    })
    |> list.sized_chunk(3)

  case subgrid {
    [[Ok(tl), Ok(t), Ok(tr)], [Ok(l), Ok(c), Ok(r)], [Ok(bl), Ok(b), Ok(br)]] ->
      todo
    _ -> 0
  }
  todo
  // let ele =
  //   grid |> glearray.get(ri) |> result.then(fn(x) { glearray.get(x, ci) })
  // let left =
  //   grid |> glearray.get(ri) |> result.then(fn(x) { glearray.get(x, ci - 1) })
  // let right =
  //   grid |> glearray.get(ri) |> result.then(fn(x) { glearray.get(x, ci + 1) })
  // let top =
  //   grid |> glearray.get(ri - 1) |> result.then(fn(x) { glearray.get(x, ci) })
  // let bottom =
  //   grid |> glearray.get(ri + 1) |> result.then(fn(x) { glearray.get(x, ci) })
  //
  // case ele == left, ele == right, ele == top, ele == bottom {
  //   False, False, False, False -> 4
  //   // No connected pieces
  //   False, False, False, True
  //   | False, False, True, False
  //   | False, True, False, False
  //   | True, False, False, False
  //   -> 2
  //   // Exactly one connected piece
  //   True, False, True, False
  //   | False, True, False, True
  //   | True, False, False, True
  //   | False, True, True, False
  //   -> 1
  //   // Corners
  //   _, _, _, _ -> 0
  //   // 3 or more(4) connected areas
  // }
}

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
    Error(_) -> #(vis, 0, 0)
    Ok(x) if x != target -> #(vis, 0, 0)
    Ok(_) ->
      case vis |> set.contains(#(ri, ci)) {
        False ->
          list.fold(
            [#(0, 1), #(0, -1), #(1, 0), #(-1, 0)],
            #(vis |> set.insert(#(ri, ci)), 1, vertex_count(grid, ri, ci)),
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

  let data =
    "AAAA
BBCD
BBCC
EEEC"
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
    let #(vis, a, p) = flood_fill(grid, ele, vis, ri, ci) |> io.debug
    #(vis, res + p * a)
  }.1
  |> int.to_string
  |> io.println
  |> Ok
}
