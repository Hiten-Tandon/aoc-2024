import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import utility.{get_input}

fn can_move(
  graph_data: Dict(#(Int, Int), String),
  position: #(Int, Int),
  delta: #(Int, Int),
) -> Bool {
  case dict.get(graph_data, position) {
    Error(Nil) -> True
    Ok("#") -> False
    Ok("[") -> {
      let #(nr, nc) = #(position.0 + delta.0, position.1 + delta.1)
      case delta {
        #(0, 1) -> can_move(graph_data, #(nr, nc + 1), delta)
        #(0, -1) -> can_move(graph_data, #(nr, nc - 1), delta)
        _ ->
          can_move(graph_data, #(nr, nc), delta)
          && can_move(graph_data, #(nr, nc + 1), delta)
      }
    }
    Ok("]") -> {
      let #(nr, nc) = #(position.0 + delta.0, position.1 + delta.1)
      case delta {
        #(0, -1) -> can_move(graph_data, #(nr, nc - 1), delta)
        #(0, 1) -> can_move(graph_data, #(nr, nc + 1), delta)
        _ ->
          can_move(graph_data, #(nr, nc), delta)
          && can_move(graph_data, #(nr, nc - 1), delta)
      }
    }
    Ok(_) -> {
      let #(nr, nc) = #(position.0 + delta.0, position.1 + delta.1)
      can_move(graph_data, #(nr, nc), delta)
    }
  }
}

fn move_player(
  graph_data: Dict(#(Int, Int), String),
  position: #(Int, Int),
  delta: #(Int, Int),
) -> Dict(#(Int, Int), String) {
  case dict.get(graph_data, position), delta {
    Ok("["), #(dr, dc) if dr != 0 -> {
      let rposition = #(position.0, position.1 + 1)
      let npl = #(position.0 + dr, position.1 + dc)
      let npr = #(rposition.0 + dr, rposition.1 + dc)
      graph_data
      |> move_player(npl, delta)
      |> move_player(npr, delta)
      |> dict.delete(position)
      |> dict.delete(rposition)
      |> dict.insert(npl, "[")
      |> dict.insert(npr, "]")
    }
    Ok("]"), #(dr, dc) if dr != 0 -> {
      let lposition = #(position.0, position.1 - 1)
      let npl = #(lposition.0 + dr, lposition.1 + dc)
      let npr = #(position.0 + dr, position.1 + dc)
      graph_data
      |> move_player(npl, delta)
      |> move_player(npr, delta)
      |> dict.delete(lposition)
      |> dict.delete(position)
      |> dict.insert(npl, "[")
      |> dict.insert(npr, "]")
    }
    Ok(x), #(dr, dc) -> {
      let np = #(position.0 + dr, position.1 + dc)
      graph_data
      |> move_player(np, delta)
      |> dict.delete(position)
      |> dict.insert(np, x)
    }
    Error(_), _ -> graph_data
  }
}

pub fn main() {
  use data <- result.try(get_input(15))

  let assert Ok(#(grid, moves)) = data |> string.split_once("\n\n")
  let grid_data =
    grid
    |> string.trim
    |> string.replace("#", "##")
    |> string.replace(".", "..")
    |> string.replace("O", "[]")
    |> string.replace("@", "@.")
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
          "#" | "[" | "]" | "@" -> dict.insert(mp, #(ri, ci), ele)
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
      case can_move(grid_data, player, move) {
        True -> move_player(grid_data, player, move)
        False -> grid_data
      }
    },
  )
  |> dict.filter(fn(_, v) { v == "[" })
  |> dict.keys
  |> list.map(fn(x) { x.0 * 100 + x.1 })
  |> list.fold(0, int.add)
  |> int.to_string
  |> io.println
  |> Ok
}
