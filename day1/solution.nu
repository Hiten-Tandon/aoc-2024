export def part1 [] {
  let data = (
    open ~/.cache/aoc/2024/day1/input.txt
      | lines 
      | each {$in | split words}
      | into record 
      | transpose
  );

  let sol = (
    $data.column0 
      | sort 
      | zip ($data.column1 | sort) 
      | each {($in.1 | into int) - ($in.0 | into int) | math abs} 
      | math sum
  );

  wl-copy $sol
  $sol
}

export def part2 [] {
  let data = (
    open ~/.cache/aoc/2024/day1/input.txt
      | lines 
      | each {$in | split words}
      | into record 
      | transpose
  );
  let counts = (
    $data.column1 
    | reduce --fold 
        ($data.column1 | each {[$in 0]} | into record) 
        {|x, acc| $acc | update $x {$in + 1}}
  );
  let sol = (
    $data.column0 
      | each {|x| ($counts | get $x -i | default 0) * ($x | into int)} 
      | math sum
  );

  wl-copy $sol
  $sol
}
