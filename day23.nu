export def part1 [] {
  let connections = (
    open ~/.cache/aoc/2024/day23/input.txt
      | lines
      | each { [$in ($in | split row "-" | reverse | str join "-")] } 
      | flatten
      | each { split column "-" c1 c2 }
      | flatten
      | group-by c1 --to-table
      | update items {select c2}
  );

  let t_conns = (
    $connections 
      | where group starts-with "t"
      | update items { |x| 
        $x.items | each {|item|
          $connections | where group == $item.c2
        }
      | flatten
      }
      | flatten 
      | flatten 
      | flatten 
      | flatten 
      | rename -c {items_group: c1}
    )
  let res = (
    $t_conns
      | par-each {|x| 
          $t_conns 
          | filter {|y| $y.group == $x.group and $y.c1 == $x.c2 and $y.c2 == $x.c1}
      }
      | flatten
      | par-each { $in | values | sort } 
      | uniq
      | length
  )
  wl-copy $res
  $res
}
