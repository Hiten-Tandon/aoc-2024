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
  use std/iter
  let data = "2333133121414131402" # open ~/.cache/aoc/2024/day9/input.txt 
            | str trim 
            | split chars 
            | each { $in | into int } 
            | iter scan 0 {|x, y| $x + $y}
            | window 2 
            | enumerate

  let files = $data 
            | filter {$in.index mod 2 == 0} 
            | each { {fname: ($in.index // 2), start: $in.item.0, end: $in.item.1} }
  let spaces = $data 
            | filter {$in.index mod 2 != 0 and $in.item != 0} 
            | each { {start: $in.item.0, end: $in.item.1} }
  {files: $files spaces: $spaces}
}
