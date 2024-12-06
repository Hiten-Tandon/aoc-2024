export def initialize [day: int] {
  if ($"($env.HOME)/.cache/aoc/2024/day($day)/input.txt" | path exists) {
    return
  }
  mkdir $"($env.HOME)/.cache/aoc/2024/day($day)"
  http get $"https://adventofcode.com/2024/day/($day)/input" --headers [Cookie $"session=(open $"($env.HOME)/.cache/aoc/SESSION_COOKIE.txt" | str trim)"]
    | save $"($env.HOME)/.cache/aoc/2024/day($day)/input.txt"
}

export def clear_cache [] {
  rm -rf ~/.cache/aoc/2024
}
