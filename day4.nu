# This works, but don't run it, it takes like 5 minutes.
export def part1 [] {
  let grid = (
    open ~/.cache/aoc/2024/day4/input.txt 
      | lines
      | each {$in | split chars}
  )
  let row_count = $grid | length
  let col_count = $grid | get 0 | length
  let grid = $grid | flatten
  
  def dfs [x: int, y: int, dx: int, dy: int, pos: int] : int {
    if not ($x in 0..<$row_count) or not ($y in 0..<$col_count) {
      return 0;
    }
    let $ele = $grid | get ($x * $col_count + $y)
    match [$pos $ele] {
      [0 X] | [1 M] | [2 A] => (dfs ($x + $dx) ($y + $dy) $dx $dy ($pos + 1))
      [3 S] => 1
      _ => 0
    }
  }
  
  let res = (0..<$row_count 
    | par-each {|row|  
      0..<$col_count
      | par-each {|col| [[0 1] [0 -1] [1 0] [-1 0] [-1 -1] [1 1] [-1 1] [1 -1]] | each {|delta| dfs $row $col $delta.0 $delta.1 0} | math sum } | math sum } | math sum);

  wl-copy $res;
  $res
}

export def part2 [] {
  let res = (open ~/.cache/aoc/2024/day4/input.txt
    | lines
    | each {$in | split chars }
    | window 3
    | each {|w| $w.0 | zip $w.1 | zip $w.2 | each {flatten} | window 3}
    | flatten
    | each {
      match $in {
        [
          [M _ M]
          [_ A _]
          [S _ S]
        ] | [
          [S _ M]
          [_ A _]
          [S _ M]
        ] | [
          [M _ S]
          [_ A _]
          [M _ S]
        ] | [
          [S _ S]
          [_ A _]
          [M _ M]
        ] => 1
        _ => 0
      }
    } | math sum)
  wl-copy $res;
  $res
} 
