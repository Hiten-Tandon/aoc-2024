export def part1 [] {
  let p = open ~/.cache/aoc/2024/day19/input.txt 
    | split row "\n\n" 
    | first 
    | split row ", " 
    | each { str trim }
    | str join "|"
  let res = rg --regexp=$"^\(($p)\)+$" --color=never --no-filename --mmap -Noc ~/.cache/aoc/2024/day19/input.txt
  wl-copy $res
  $res
}

export def part2 [] {
  stor open
    | query db "CREATE TABLE day19_cache (id INTEGER PRIMARY KEY, pattern TEXT UNIQUE, count INTEGER DEFAULT 0)"

  let towels = (
    open ~/.cache/aoc/2024/day19/input.txt 
      | split row "\n\n" 
      | first 
      | split row ", " 
      | each { str trim }
  )
  mut store = (open ~/.cache/aoc/2024/day19/input.txt | split row "\n\n" | last | lines | each { $in })
  mut req_patterns = (0..<($store | length) | collect { |x| [$x] })
  mut res = 0
  while ($req_patterns | length) != 0 {
    let req = $req_patterns | last
    $req_patterns = $req_patterns | drop
    let curr = $store | get ($req | last)
    if $curr == "" {
      let store = $store
      let vals = $req
        | drop 
        | each { $"\(($store | get $in), 1\)" }
        | str join ",\n"
      stor open
        | query db "
INSERT INTO day19_cache (pattern, count) 
VALUES 
  :values
ON CONFLICT (pattern) DO UPDATE SET count = count + 1
"
      $res += (stor open | query db "SELECT count FROM day19_cache WHERE pattern = ?" -p [($req | first)]).count.0
      continue;
    }
    let cache_data = (stor open | query db "SELECT count FROM day19_cache WHERE pattern = ?" -p [$curr])
    if ($cache_data | length) != 0 {
      $res += $cache_data.count.0
      continue;
    }

    $req_patterns = $req_patterns | append ($towels 
    | filter { $curr | str starts-with $in }
    | each { $curr | str replace $in "" }
    | each { $req | append $in })
  }

  stor delete -t day19_cache
  wl-copy $res
  $res
}
