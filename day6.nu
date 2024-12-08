export def part1 [] {
  let grid = open ~/.cache/aoc/2024/day6/input.txt | lines | each {$in | split chars}
  const deltas = {
    N: {r: -1, c: 0},
    S: {r: 1, c: 0},
    E: {r: 0, c: 1},
    W: {r: 0, c: -1},
  }

  def rotate [direction: string] string {
    match $direction {
      E => "S"
      W => "N"
      N => "E"
      S => "W"
      $x => $x
    }
  }

  
  def walk [row: int, col: int, direction: string, visited: record] record {
    let delta = ($deltas | get $direction)
    let nr = $row + $delta.r
    let nc = $col + $delta.c
    mut visited = $visited | merge { ($"\(($row), ($col)\)" | into string): 1 }

    let grid_row = $grid | get -i $nr
    if $grid_row == null {
      return $visited
    }

    let grid_ele = $grid_row | get -i $nc
    if $grid_ele == null {
      return $visited
    }

    return ($visited | merge (
      match $grid_ele {
        "." | "^" => (walk $nr $nc $direction $visited),
        "#" => (walk $row $col (rotate $direction) $visited),
      }
    ))
  }

  let spos = $grid 
    | each { $in | enumerate | filter {$in.item == "^"} } 
    | enumerate 
    | filter { ($in.item | length) != 0}
    | flatten
    | flatten
    | select index item_index
    | rename row col

  let res = ((walk $spos.row.0 $spos.col.0 N {}) | columns | length)
  wl-copy $res
  $res
}
