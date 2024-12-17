import gleam/function
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/result
import gleam/set.{type Set}
import gleam/string
import priorityq.{type PriorityQueue}
import utility.{get_input}

type Direction {
  Up
  Down
  Left
  Right
}

fn turn_clockwise(direction: Direction) -> Direction {
  case direction {
    Up -> Right
    Right -> Down
    Left -> Up
    Down -> Left
  }
}

fn turn_counter_clockwise(direction: Direction) -> Direction {
  case direction {
    Up -> Left
    Right -> Up
    Left -> Down
    Down -> Right
  }
}

fn next_in_direction(point: #(Int, Int), direction: Direction) -> #(Int, Int) {
  let #(r, c) = point
  case direction {
    Up -> #(r - 1, c)
    Right -> #(r, c + 1)
    Left -> #(r, c - 1)
    Down -> #(r + 1, c)
  }
}

type Status {
  ReachedEnd
  HitAWall
}

fn get_min_cost(
  obstacles: Set(#(Int, Int)),
  end: #(Int, Int),
  direction: Direction,
  visited: Set(#(Int, Int)),
  to_visit: PriorityQueue(#(#(Int, Int), Int)),
) -> #(Status, Int) {
  let #(position, cost) =
    priorityq.peek(to_visit) |> option.unwrap(#(#(0, 0), 0))
  let to_visit = priorityq.pop(to_visit)
  let visited = set.insert(visited, position)
  case position == end {
    True -> {
      io.println("Reached end")
      #(ReachedEnd, cost)
    }
    False -> {
      [
        #(function.identity, 1),
        #(turn_clockwise, 1000),
        #(turn_counter_clockwise, 1000),
      ]
      |> list.map(fn(f) { #(f.0(direction), f.1) })
      |> list.map(fn(dir) {
        #(next_in_direction(position, dir.0), dir.0, dir.1)
      })
      |> list.filter(fn(x) {
        !set.contains(obstacles, x.0) && !set.contains(visited, x.0)
      })
      |> list.find_map(fn(x) {
        case get_min_cost(obstacles, end, x.1, visited, to_visit) {
          #(HitAWall, _) -> Error(Nil)
          #(ReachedEnd, x) -> Ok(#(ReachedEnd, x))
        }
      })
      |> result.unwrap(#(HitAWall, 0))
    }
  }
}

pub fn main() {
  use data <- result.try(get_input(16))
  let #(grid, start, end) =
    data
    |> string.trim
    |> string.split("\n")
    |> list.map(string.to_graphemes)
    |> list.index_fold(#(set.new(), #(0, 0), #(0, 0)), fn(acc, row, ri) {
      use #(acc, start, end), x, ci <- list.index_fold(row, acc)
      case x {
        "#" -> #(set.insert(acc, #(ri, ci)), start, end)
        "S" -> #(acc, #(ri, ci), end)
        "E" -> #(acc, start, #(ri, ci))
        _ -> #(acc, start, end)
      }
    })
  get_min_cost(
    grid,
    end,
    Right,
    set.new(),
    priorityq.from_list([#(start, 0)], fn(x, y) { int.compare(y.1, x.1) }),
  ).1
  |> int.to_string
  |> io.println
  |> Ok
}
