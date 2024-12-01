use ./get_day.nu

export def "day1 part1" [] {
  get_day initialize 1
  use ./day1/solution.nu
  solution part1
}

export def "day1 part2" [] {
  get_day initialize 1
  use ./day1/solution.nu
  solution part2
}
