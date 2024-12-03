export def part1 [] {
  let res = rg --regexp "mul\\(\\d+,\\d+\\)" ~/.cache/aoc/2024/day3/input.txt --no-line-number --no-filename --mmap -o --color never
    | lines 
    | each {($in | parse "mul({n1},{n2})" | transpose).column1}
    | each {|x| ($x.0 | into int) * ($x.1 | into int)}
    | math sum;
  wl-copy $res
  $res
}

export def part2 [] {
  let res = (rg --regexp "(mul\\(\\d+,\\d+\\))|(do(n't)?\\(\\))" ~/.cache/aoc/2024/day3/input.txt --no-line-number --no-filename --mmap -o --color never
    | lines 
    | reduce --fold [0 true] {|x, acc|
      match $x {
        "do" => [$acc.0 true],
        "don't" => [$acc.0 false],
        $y if $acc.1 == true => {
          let temp = ($y | parse "mul({n1},{n2})" | transpose).column1;
          [($acc.0 + ($temp.0 | into int) * ($temp.1 | into int)) $acc.1]
        }
        _ => $acc
      }
    }).0
  wl-copy $res
  $res
}
