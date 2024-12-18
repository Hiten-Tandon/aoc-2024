export def part1 [] {
  let corrupted_blocks = (
    open ~/.cache/aoc/2024/day18/input.txt
      | lines
      | take 1024
      | reduce --fold {} {|x, acc| $acc | merge {$x: true} }
    )
  mut visited = {}
  mut stack = [[0, 0, 0]]

  while ($stack | length) != 0 {
    let data = $stack | last
    $stack = $stack | drop

    if (
        ($corrupted_blocks | get -i $"($data.0),($data.1)" | default false) 
        or (($visited | get -i $"($data.0),($data.1)" | default (2 ** 32)) <= $data.2)
        or ($data.0 < 0 or $data.0 > 70 or $data.1 < 0 or $data.1 > 70)
    ) {
      continue;
    }

    if $data.0 == 70 and $data.1 == 70 {
      wl-copy $data.2
      return $data.2
    }

    $visited = $visited | merge { ($"($data.0),($data.1)"): $data.2}
    $stack = (
      $stack 
        | append [
          [$data.0, ($data.1 - 1), ($data.2 + 1)],
          [$data.0, ($data.1 + 1), ($data.2 + 1)],
          [($data.0 - 1), $data.1, ($data.2 + 1)],
          [($data.0 + 1), $data.1, ($data.2 + 1)],
        ] 
        | sort-by -r { last }
    )
  }
}

export def part2 [] {
  let corrupted_blocks = (open ~/.cache/aoc/2024/day18/input.txt | lines | each { str trim })
  mut dsu = {}
  mut lefts = []
  mut rights = []
  mut tops = []
  mut bottoms = []

  def get_par [dsu: record, u: string] any {
    mut res = $u
    while $res != null and ($dsu | get -i $res) != $res {
      $res = $dsu | get -i $res
    }
    $res
  }

  def merge_dsu [dsu: record, u: string, v: string] record {
    let u_par = get_par $dsu $u
    let v_par = get_par $dsu $v

    if $u_par == null or $v_par == null { 
      $dsu
    } else {
      $dsu | update $u_par $v_par | update $u $v_par | update $v $v_par
    }
  }

  for x in ($corrupted_blocks | enumerate) {
    $dsu = $dsu | insert $x.item $x.item
    let neighbors = [[0, -1], [0, 1], [-1, 0], [1, 0], [1, 1], [1, -1], [-1, -1], [-1, 1]] 
    | each {
      let temp = $x.item | split row , | each { str trim | into int }
      [($temp.0 + $in.0), ($temp.1 + $in.1)] | str join ,
    }

    for n in $neighbors {
      $dsu = merge_dsu $dsu $x.item $n
    }

    let temp = $x.item | split row , | each { into int }
    if $temp.0 == 0 {
      $tops = $tops | append $x.item
    } else if $temp.0 == 70 {
      $bottoms = $bottoms | append $x.item
    } else if $temp.1 == 0 {
      $lefts = $lefts | append $x.item
    } else if $temp.1 == 70 {
      $rights = $rights | append $x.item
    }
    let temp = $dsu
    $lefts = $lefts | each { get_par $temp $in } | uniq
    $rights = $rights | each { get_par $temp $in } | uniq
    $tops = $tops | each { get_par $temp $in } | uniq
    $bottoms = $bottoms | each { get_par $temp $in } | uniq

    for l in $lefts {
      for r in $rights {
        if $l == $r {
          wl-copy $x.item
          return $x.item
        }
      }

      for t in $tops {
        if $l == $t {
          wl-copy $x.item
          return $x.item
        }
      }
    }

    for b in $bottoms {
      for r in $rights {
        if $b == $r {
          wl-copy $x.item
          return $x.item
        }
      }

      for t in $tops {
        if $b == $t {
          wl-copy $x.item
          return $x.item
        }
      }
    }
  }
}
