export def part1 [] {
  let res = (
    open ~/.cache/aoc/2024/day13/input.txt
      | split row "\n\n"
      | each { 
        lines 
        | each { split column ': ' } 
        | flatten 
        | transpose --header-row 
        | update cells { 
          split column ', ' 
          | update cells { (split row -r '\+|=').1 | into int } 
          | rename --column {column1: X, column2: Y}
        }
      }
      | flatten
      | flatten "Button A"
      | flatten "Button B"
      | flatten Prize
      | flatten
      | rename --column {X: X1, Y: Y1, "Button B_X": X2, "Button B_Y": Y2, Prize_X: PX, Prize_Y: PY}
      | insert C1 { ($in.Y2 * $in.PX - $in.PY * $in.X2) // ($in.X1 * $in.Y2 - $in.X2 * $in.Y1) }
      | insert C2 { ($in.Y1 * $in.PX - $in.PY * $in.X1) // ($in.X2 * $in.Y1 - $in.X1 * $in.Y2 ) }
      | filter { 
        (($in.X1 * $in.C1 + $in.X2 * $in.C2) == $in.PX 
        and ($in.Y1 * $in.C1 + $in.Y2 * $in.C2) == $in.PY)
      }
      | each { $in.C1 * 3 + $in.C2 }
      | math sum
  )
  wl-copy $res
  $res
}

export def part2 [] {
  let res = (
    open ~/.cache/aoc/2024/day13/input.txt
      | split row "\n\n"
      | each { 
        lines 
        | each { split column ': ' } 
        | flatten 
        | transpose --header-row 
        | update cells { 
          split column ', ' 
          | update cells { (split row -r '\+|=').1 | into int } 
          | rename --column {column1: X, column2: Y}
        }
        | update Prize { update cells { $in + 10_000_000_000_000 } }
      }
      | flatten
      | flatten "Button A"
      | flatten "Button B"
      | flatten Prize
      | flatten
      | rename --column {X: X1, Y: Y1, "Button B_X": X2, "Button B_Y": Y2, Prize_X: PX, Prize_Y: PY}
      | insert C1 { ($in.Y2 * $in.PX - $in.PY * $in.X2) // ($in.X1 * $in.Y2 - $in.X2 * $in.Y1) }
      | insert C2 { ($in.Y1 * $in.PX - $in.PY * $in.X1) // ($in.X2 * $in.Y1 - $in.X1 * $in.Y2 ) }
      | filter { 
        (($in.X1 * $in.C1 + $in.X2 * $in.C2) == $in.PX 
        and ($in.Y1 * $in.C1 + $in.Y2 * $in.C2) == $in.PY)
      }
      | each { $in.C1 * 3 + $in.C2 }
      | math sum
  )
  wl-copy $res
  $res
}
