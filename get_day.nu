export def initialize [day: int] {
  if ($"($env.HOME)/.cache/aoc/2024/day($day)/input.txt" | path exists) {
    return
  }
  mkdir $"($env.HOME)/.cache/aoc/2024/day($day)"
  curl -s --cookie $"session=(open $"($env.HOME)/.cache/aoc/SESSION_COOKIE.txt")" $"https://adventofcode.com/2024/day/($day)/input" 
    | save $"($env.HOME)/.cache/aoc/2024/day($day)/input.txt"
}

export def clear_cache [] {
  rm -rf ~/.cache/aoc/2024
}
