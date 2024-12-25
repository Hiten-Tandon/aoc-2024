export def part1 [] {
  let grids = (
    open ~/.cache/aoc/2024/day25/input.txt  
      | split row "\n\n"
      | each { lines | split chars }
  )

  let grid_len = ($grids | length)

  def do_grids_overlap [grid1: list<list<string>>, grid2: list<list<string>>] bool {
    for r in 0..6 {
      for c in 0..4 {
        if (($grid1 | get $r | get $c) == "#") and (($grid2 | get $r | get $c) == "#") {
          return true;
        }
      }
    }
    return false;
  }

  let res = (
    (0..<$grid_len) | par-each {|i|
      let grid1 = $grids | get $i
      if ($i + 1) == $grid_len {
        return 0
      }
      (($i + 1)..<$grid_len) | par-each {|j|
        let grid2 = $grids | get $j
        if (do_grids_overlap $grid1 $grid2) {
          return 0;
        }
        return 1
      } | math sum
    }
    | math sum
  )

  wl-copy $res
  $res
}
