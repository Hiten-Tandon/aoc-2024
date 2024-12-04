use get_day.nu
use day1.nu
use day2.nu
use day3.nu
use day4.nu
use std/log

export def "solve day1 part1" [] {
  get_day initialize 1
  day1 part1
}

export def "solve day1 part2" [] {
  get_day initialize 1
  day1 part2
}

export def "solve day2 part1" [] {
  get_day initialize 2
  day2 part1
}

export def "solve day2 part2" [] {
  get_day initialize 2
  day2 part2
}

export def "solve day3 part1" [] {
  get_day initialize 3
  day3 part1
}

export def "solve day3 part2" [] {
  get_day initialize 3
  day3 part2
}


export def "solve day4 part1" [] {
  log warning "This can take ages, if you don't have time please don't run"
  get_day initialize 4
  day4 part1
}

export def "solve day4 part2" [] {
  get_day initialize 4
  day4 part2
}
