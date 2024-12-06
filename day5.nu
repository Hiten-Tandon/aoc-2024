def part1 [] {
  let data = open ~/.cache/aoc/2024/day5/input.txt
    | lines
    | split list ""

  let orders = $data.0 | each {$in | split row "|" | each {str trim}}
  let updates = $data.1 | each {$in | split row "," | each {str trim}}
  
  $updates 
    | each {
      {
        og_list: $in,
        idx_map: ($in | enumerate | each { {$in.item: $in.index} } | reduce --fold {} {|x, acc| $acc | merge $x})
      }
    } | filter {|x| 
      $orders | filter {
        ($x | get -i $in.0 != null) and ($x | get -i $in.1 != null)
      }
    }
}
