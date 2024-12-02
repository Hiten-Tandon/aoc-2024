# This is the solution runner script
export def part1 [] {
  let data = (
    open ~/.cache/aoc/2024/day2/input.txt
      | lines
      | each {
        $in | split words 
            | each {$in | into int} 
            | window 2 
        }
      | filter {
          (
            (($in | all {$in.0 < $in.1}) or ($in | all {$in.0 > $in.1}))
            and ($in | all {($in.0 - $in.1 | math abs) in 1..3})
          )
        }
      | length
  );
  wl-copy $data
  $data
}

export def part2 [] {
  let data = (
    open ~/.cache/aoc/2024/day2/input.txt
      | lines
      | par-each {$in | split words | each {$in | into int}}
      | filter {|ls|
          (0..<($ls | length)) | par-each {|pos| $ls | drop nth $pos | window 2} | any {
            (
              (($in | all {$in.0 < $in.1}) or ($in | all {$in.0 > $in.1}))
              and ($in | all {($in.0 - $in.1 | math abs) in 1..3})
            )
          }
        }
      | length
  );
  wl-copy $data
  $data
}

