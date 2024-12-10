export def part1 [] {
  let data = open ~/.cache/aoc/2024/day8/input.txt 
      | lines 
      | each {$in | split chars} 
  
  let row_count = $data | length
  let col_count = $data.0 | length
  mut seen = {}
  mut val_sets = {}

  for $it in ($data | enumerate) {
    for $ele in ($it.item | enumerate) {
      if $ele.item == "." {
        continue
      }

      $val_sets = $val_sets | upsert $ele.item {($in | default []) | append [[$it.index $ele.index]]}
    }
  }

  for v in ($val_sets | values) {
    let len = $v | length
    for i in 0..<$len {
      let p1 = $v | get $i
      for j in ($i + 1)..<$len {
        let p2 = $v | get $j
        let dx = $p2.0 - $p1.0
        let dy = $p2.1 - $p1.1

        let npx1 = $p1.0 - $dx
        let npy1 = $p1.1 - $dy
        let npx2 = $p2.0 + $dx
        let npy2 = $p2.1 + $dy

        if $npx1 in 0..<$row_count and $npy1 in 0..<$col_count {
          let key = $"\(($npx1), ($npy1)\)"
          $seen = $seen | upsert $key true
        }

        if $npx2 in 0..<$row_count and $npy2 in 0..<$col_count {
          let key = $"\(($npx2), ($npy2)\)"
          $seen = $seen | upsert $key true
        }
      }
    }
  }

  $seen | columns | length
}


export def part2 [] {
  let data = open ~/.cache/aoc/2024/day8/input.txt
  let data = "............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............"
      | lines 
      | each {$in | split chars} 
  
  let row_count = $data | length
  let col_count = $data.0 | length
  mut seen = {}
  mut val_sets = {}

  for $it in ($data | enumerate) {
    for $ele in ($it.item | enumerate) {
      if $ele.item == "." {
        continue
      }

      $val_sets = $val_sets | upsert $ele.item {($in | default []) | append [[$it.index $ele.index]]}
    }
  }

  for v in ($val_sets | values) {
    let len = $v | length
    for i in 0..<$len {
      let p1 = $v | get $i
      for j in ($i + 1)..<$len {
        let p2 = $v | get $j
        let dx = $p2.0 - $p1.0
        let dy = $p2.1 - $p1.1

        mut npx = $p1.0 - $dx 
        mut npy = $p1.1 - $dy

        while $npx in 0..<$row_count and $npy in 0..<$col_count {
          $seen = $seen | upsert $"\(($npx), ($npy)\)" true
          $npx -= $dx
          $npy -= $dy
        }

        $npx = $p2.0 + $dx
        $npy = $p2.1 + $dy

        while $npx in 0..<$row_count and $npy in 0..<$col_count {
          $seen = $seen | upsert $"\(($npx), ($npy)\)" true
          $npx += $dx
          $npy += $dy
        }
      }
    }
  }

  $seen
}
