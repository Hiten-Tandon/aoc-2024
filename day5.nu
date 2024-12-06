export def part1 [] {
  let data = open ~/.cache/aoc/2024/day5/input.txt
    | lines
    | split list ""

  let orders = $data.0 | each {$in | split row "|" | each {str trim}}
  let updates = $data.1 | each {$in | split row "," | each {str trim}}

  let res = (
    $updates 
      | each {
          {
            og_list: $in,
            idx_map: ($in | enumerate | each { {$in.item: $in.index} } | reduce --fold {} {|x, acc| $acc | merge $x})
          }
        } 
      | filter {|x| 
          $orders 
            | filter {|y| ($x.idx_map | get -i $y.0) != null and ($x.idx_map | get -i $y.1) != null }
            | all {|ordering| (($x.idx_map | get $ordering.0) | into int) < (($x.idx_map | get $ordering.1) | into int) }
        } 
      | each {|x| $x.og_list | (get (($x.og_list | length) // 2)) | into int} 
      | math sum
  )

  wl-copy $res
  $res
}

export def part2 [] {
  let data = open ~/.cache/aoc/2024/day5/input.txt
    | lines
    | split list ""

  let orders = $data.0 | each {$in | split row "|" | each {str trim}}
  let updates = $data.1 | each {$in | split row "," | each {str trim}}

  let res = (
    $updates 
      | each {
          {
            og_list: $in,
            idx_map: ($in | enumerate | each { {$in.item: $in.index} } | reduce --fold {} {|x, acc| $acc | merge $x})
          }
        } 
      | filter {|x| 
          $orders 
            | filter {|y| ($x.idx_map | get -i $y.0) != null and ($x.idx_map | get -i $y.1) != null }
            | any {|ordering| (($x.idx_map | get $ordering.0) | into int) >= (($x.idx_map | get $ordering.1) | into int) }
        } 
      | each {|x| 
          let sub_ordering = $orders 
              | filter {|y| ($x.idx_map | get -i $y.0) != null and ($x.idx_map | get -i $y.1) != null }
          $x.og_list | sort-by -c {|a, b|
              $sub_ordering | any {$in == [$a $b]}
          } 
        } 
      | each {|x| $x | (get (($x | length) // 2)) | into int } 
      | math sum
  )

  wl-copy $res
  $res
}
