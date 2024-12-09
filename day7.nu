export def part1 [] {
  let data = open ~/.cache/aoc/2024/day7/input.txt 
      | lines 
      | each {$in | split column ": "} 
      | flatten 
      | update column2 {$in | split words | each {$in | into int}}
      | update column1 {$in | into int}

  def helper [req: int, acc: int, vals: list<int>] bool {
    if ($vals | length) == 0 {
      return ($acc == $req)
    }

    return ((helper $req ($acc + ($vals | first)) ($vals | skip 1)) or (helper $req ($acc * ($vals | first)) ($vals | skip 1)))
  }

  let res = $data.column1 | zip $data.column2 | filter {helper $in.0 0 $in.1} | each {$in.0} | math sum
  wl-copy $res
  $res
}

export def part2 [] {
  let data = open ~/.cache/aoc/2024/day7/input.txt 
      | lines 
      | each {$in | split column ": "} 
      | flatten 
      | update column2 {$in | split words | each {$in | into int}}
      | update column1 {$in | into int}

  def helper [req: int, acc: int, vals: list<int>] bool {
    if ($vals | length) == 0 {
      return ($acc == $req)
    }

    return (
      (helper $req ($acc + ($vals | first)) ($vals | skip 1)) 
      or (helper $req ($acc * ($vals | first)) ($vals | skip 1))
      or (helper $req (($acc | into string) + ($vals | first | into string) | into int) ($vals | skip 1))
    )
  }

  let res = $data.column1 
      | zip $data.column2 
      | par-each {[$in (helper $in.0 0 $in.1)]} 
      | filter {$in.1} 
      | each {$in.0.0} 
      | math sum
  wl-copy $res
  $res
}
