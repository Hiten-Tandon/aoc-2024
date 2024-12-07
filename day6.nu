export def part1 [] {
  let grid = open ~/.cache/aoc/2024/day6/input.txt | lines | each {$in | split chars}
  const deltas = {
    N: {r: -1, c: 0},
    S: {r: 1, c: 0},
    E: {r: 0, c: 1},
    W: {r: 0, c: -1},
  }

  def walk [row: int, col: int, direction: string, visited: record] record {
      }
}
