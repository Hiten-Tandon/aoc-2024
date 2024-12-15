export def part1 [] {
  const WIDTH = 101
  const HEIGHT = 103
  const TIME_ELAPSED = 100
  let data = open ~/.cache/aoc/2024/day14/input.txt
    | lines
    | each { 
      (
        split row -r '\s+|=|,'
        | chunks 3
        | each { skip 1 | each { into int } }
        | flatten
        | enumerate
        | transpose px_i py_i vx vy --ignore-titles
      ).1 
    }
    | insert px_f { ($in.px_i + $in.vx * $TIME_ELAPSED) mod $WIDTH }
    | insert py_f { ($in.py_i + $in.vy * $TIME_ELAPSED) mod $HEIGHT }
    | select px_f py_f 

  let q1 = $data | filter { $in.px_f < $WIDTH // 2 and $in.py_f < $HEIGHT // 2 } | length
  let q2 = $data | filter { $in.px_f < $WIDTH // 2 and $in.py_f > $HEIGHT // 2 } | length
  let q3 = $data | filter { $in.px_f > $WIDTH // 2 and $in.py_f < $HEIGHT // 2 } | length
  let q4 = $data | filter { $in.px_f > $WIDTH // 2 and $in.py_f > $HEIGHT // 2 } | length

  let res = $q1 * $q2 * $q3 * $q4
  wl-copy $res
  $res
}

export def part2 [] {
  const WIDTH = 101
  const HEIGHT = 103
  const TIME_ELAPSED = 100
  let data = open ~/.cache/aoc/2024/day14/input.txt
    | lines
    | each { 
      (
        split row -r '\s+|=|,'
        | chunks 3
        | each { skip 1 | each { into int } }
        | flatten
        | enumerate
        | transpose px py vx vy --ignore-titles
      ).1 
    }
  mut res_x = (
    0..$WIDTH
      | each {|idx|  
          ($data | update px {|row| ($row.px + $row.vx * $idx) mod $WIDTH }).px | math variance
      }
      | enumerate 
      | reduce {|x acc| if $x.item < $acc.item { $x } else { $acc } }
  ).index

  let res_y = (
    0..$HEIGHT 
      | each {|idx|  
          ($data | update py {|row| ($row.py + $row.vy * $idx) mod $HEIGHT }).py | math variance
      }
      | enumerate 
      | reduce {|x acc| if $x.item < $acc.item { $x } else { $acc } }
  ).index

  while $res_x mod $HEIGHT != $res_y {
    $res_x += $WIDTH
  }

  wl-copy $res_x
  $res_x
}

export def "part2 images" [] {
  const WIDTH = 101
  const HEIGHT = 103
  const TIME_ELAPSED = 100
  let data = open ~/.cache/aoc/2024/day14/input.txt
    | lines
    | each { 
      (
        split row -r '\s+|=|,'
        | chunks 3
        | each { skip 1 | each { into int } }
        | flatten
        | enumerate
        | transpose px py vx vy --ignore-titles
      ).1 
    }

  0..($WIDTH * $HEIGHT)
  | par-each {|idx|
      print $"($in)"
      { 
        path: $"($env.HOME)/.cache/aoc/2024/day14/image-($idx).txt",
        data: (
          $data 
          | update px {|row| ($row.px + $row.vx * $idx) mod $WIDTH }
          | update py {|row| ($row.py + $row.vy * $idx) mod $HEIGHT }
          | reduce --fold (0..<$HEIGHT | each { 0..<$WIDTH | each { " " } }) {|x acc| 
            $acc | update $x.py { update $x.px "." }
          } 
          | each {str join} 
          | str join "\n"
        )
      }
    }
    | each {|x| $x.data | save $x.path -f }
}

export def "part2 animation" [] {
  0..(part2) 
  | each { 
      clear 
      cat $"($env.HOME)/.cache/aoc/2024/day14/image-($in).txt"
      sleep 0.1sec
    }
}
