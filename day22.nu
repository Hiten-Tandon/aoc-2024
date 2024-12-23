export def part1 [] {
  let res = (
    open ~/.cache/aoc/2024/day22/input.txt
      | lines
      | each { into int }
      | par-each {|x|
        (1..2000) | reduce --fold $x { |_, acc|
          let acc = ($acc * 64 | bits xor $acc) mod 16777216
          let acc = ($acc // 32 | bits xor $acc) mod 16777216
          ($acc * 2048 | bits xor $acc) mod 16777216
        }
      }
      | math sum
  )
  wl-copy $res
  $res
}
export def part2 [] {
  use std/iter
  let res = (
    open ~/.cache/aoc/2024/day22/input.txt
      | lines
      | par-each { into int }
      | par-each {|x|
        (1..2000) | iter scan $x { |acc, _|
          let acc = ($acc * 64 | bits xor $acc) mod 16777216
          let acc = ($acc // 32 | bits xor $acc) mod 16777216
          ($acc * 2048 | bits xor $acc) mod 16777216
        }
        | each { $in mod 10 }
        | window 2
        | each { {diff: ($in.1 - $in.0), val: $in.1} }
        | window 4
        | uniq-by diff
        | par-each { { diff: ($in.diff | each { into string } | str join ,), val: $in.val.3 } }
      }
      | flatten
      | group-by diff --to-table
      | par-each { $in.items | each {$in.val} | math sum } 
      | math max
  )
  wl-copy $res
  $res
}
