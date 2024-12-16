import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import utility.{get_input}

type Status {
  HitAWall
  Pushed
}

fn move_player(
  graph_data: Dict(#(Int, Int), String),
  position: #(Int, Int),
  delta: #(Int, Int),
) -> #(Status, Dict(#(Int, Int), String)) {
  case dict.get(graph_data, position) {
    Error(Nil) -> #(Pushed, graph_data)
    Ok("#") -> #(HitAWall, graph_data)
    Ok(ele) -> {
      let #(nr, nc) = #(position.0 + delta.0, position.1 + delta.1)
      let #(push_status, graph_data) = move_player(graph_data, #(nr, nc), delta)
      #(push_status, case push_status {
        HitAWall -> graph_data
        Pushed ->
          graph_data |> dict.delete(position) |> dict.insert(#(nr, nc), ele)
      })
    }
  }
}

pub fn main() {
  use data <- result.try(get_input(15))
  let assert Ok(#(grid, moves)) = data |> string.split_once("\n\n")
  let grid_data =
    grid
    |> string.trim
    |> string.split("\n")
    |> list.map(string.to_graphemes)
    |> list.index_fold(
      dict.new(),
      fn(mp: Dict(#(Int, Int), String), row: List(String), ri: Int) -> Dict(
        #(Int, Int),
        String,
      ) {
        use mp, ele, ci <- list.index_fold(row, mp)
        case ele {
          "#" | "O" | "@" -> dict.insert(mp, #(ri, ci), ele)
          _ -> mp
        }
      },
    )

  moves
  |> string.to_graphemes
  |> list.filter_map(fn(x) {
    case x {
      "^" -> Ok(#(-1, 0))
      "v" -> Ok(#(1, 0))
      "<" -> Ok(#(0, -1))
      ">" -> Ok(#(0, 1))
      _ -> Error(Nil)
    }
  })
  |> list.fold(
    grid_data,
    fn(grid_data: Dict(#(Int, Int), String), move: #(Int, Int)) -> Dict(
      #(Int, Int),
      String,
    ) {
      let assert [#(player, _)] =
        dict.filter(grid_data, fn(_, val) { val == "@" }) |> dict.to_list
      move_player(grid_data, player, move).1
    },
  )
  |> dict.filter(fn(_, v) { v == "O" })
  |> dict.keys
  |> list.map(fn(x) { x.0 * 100 + x.1 })
  |> list.fold(0, int.add)
  |> int.to_string
  |> io.println
  |> Ok
}
