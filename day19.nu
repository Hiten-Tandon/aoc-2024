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
  let p = open ~/.cache/aoc/2024/day19/input.txt 
    | split row "\n\n" 
    | first 
    | split row ", " 
    | each { str trim }
    | str join "|"
  rg --regexp=$"^\(?=\(($p)\)\)+$" --color=never --no-filename --mmap -Noc ~/.cache/aoc/2024/day19/input.txt --pcre2
}
