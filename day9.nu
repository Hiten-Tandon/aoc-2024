export def part1 [] {
  mut list = open ~/.cache/aoc/2024/day9/input.txt 
    | str trim 
    | split chars 
    | each { $in | into int } 
    | enumerate
    | each {|x|
      0..<$x.item 
        | each {
          if $x.index mod 2 == 0 {
            $x.index // 2
          } else {
            -1
          }
        }
    } 
    | flatten
  mut left = 0
  mut right = ($list | length) - 1
  mut counter = 0

  while $left < $right {
    let le = $list | get $left
    let re = $list | get $right

    if $counter mod 1000 == 0 {
      print $"($counter) iterations reached"
      print $"($left), ($right)"
    }

    $counter += 1

    if $le != -1 {
      $left += 1
      continue
    }

    if $re == -1 {
      $right -= 1
      continue
    }

    $list = $list | update $left $re
    $list = $list | update $right $le

    $left += 1
    $right -= 1
  }

  let res = $list | filter {$in >= 0} | enumerate | each {$in.index * $in.item} | math sum
  wl-copy $res
  $res
}

export def part2 [] {
  mut val = open ~/.cache/aoc/2024/day9/input.txt 
    | str trim 
    | split chars 
    | par-each { $in | into int } 
    | enumerate
    | reduce --fold [[] []] {|x, acc|
      if $x.index mod 2 == 0 {
        [($acc.0 | prepend [[($x.index // 2) $x.item]]) $acc.1]
      } else if $x.item != 0 {
       [$acc.0 ($acc.1 | append $x.item)]
      } else {
        $acc
      }
    } 
}
