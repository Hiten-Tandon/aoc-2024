export def part1 [] {
  let data = open ~/.cache/aoc/2024/day17/input.txt | split row "\n\n"
  mut registers = ($data.0 | lines | split column : | transpose -ir | rename -b { str replace "Register " "" } | update cells { into int }).0
  mut program = $data.1 | split row : | get 1 | str trim | split row , | each { into int } | chunks 2
  $registers = $registers | update A 307749265755624
  mut ptr = 0
  let program_len = $program | length
  mut out = []

  while $ptr < $program_len {
    let instruction = $program | get $ptr -i
    if $instruction == null {
      break;
    }
    match $instruction {
      [0, $x] if $x <= 3 => { $registers.A = $registers.A // (2 ** $x) }
      [0, 4] => { $registers.A = 0 }
      [0, 5] => { $registers.A = $registers.A // (2 ** $registers.B) }
      [0, 6] => { $registers.A = $registers.A // (2 ** $registers.C) }
      [1, $x] => { $registers.B = $x | bits xor $registers.B }
      [2, $x] if $x <= 3 => { $registers.B = $x }
      [2, 4] => { $registers.B = $registers.A mod 8 }
      [2, 5] => { $registers.B = $registers.B mod 8 }
      [2, 6] => { $registers.B = $registers.C mod 8 }
      [3, $x] => { if $registers.A != 0 { $ptr = $x // 2 } }
      [4, _] => { $registers.B = $registers.B | bits xor $registers.C }
      [5, $x] if $x <= 3 => { $out = $out | append $x }
      [5, 4] => { $out = $out | append ($registers.A mod 8) }
      [5, 5] => { $out = $out | append ($registers.B mod 8) }
      [5, 6] => { $out = $out | append ($registers.C mod 8) }
      [6, $x] if $x <= 3 => { $registers.B = $registers.A // (2 ** $x) }
      [6, 4] => { $registers.B = 0 }
      [6, 5] => { $registers.B = $registers.A // (2 ** $registers.B) }
      [6, 6] => { $registers.B = $registers.A // (2 ** $registers.C) }
      [7, $x] if $x <= 3 => { $registers.A = $registers.A // (2 ** $x) }
      [7, 4] => { $registers.C = 0 }
      [7, 5] => { $registers.C = $registers.A // (2 ** $registers.B) }
      [7, 6] => { $registers.C = $registers.A // (2 ** $registers.C) }
    }
    if ($instruction.0 == 3) and ($registers.A) != 0 {
      continue
    }
    $ptr += 1
  }

  let res = $out | each { into string } | str join ","
  wl-copy $res
  $res
}


export def part2 [] {
  let data = open ~/.cache/aoc/2024/day17/input.txt | split row "\n\n"
  let registers = ($data.0 | lines | split column : | transpose -ir | rename -b { str replace "Register " "" } | update cells { into int }).0
  let program = $data.1 | split row : | get 1 | str trim | split row , | each { into int } | chunks 2

  35_184_372_088_832..(281_474_976_710_656) | par-each {|it| 
    mut registers = $registers | update A $it
    mut ptr = 0
    let program_len = $program | length
    mut out = []
    while $ptr < $program_len {
      let instruction = $program | get $ptr -i
      if ($out | length) > $program_len {
        break;
      }
      if $instruction == null {
        break;
      }
      match $instruction {
        [0, $x] if $x <= 3 => { $registers.A = $registers.A // (2 ** $x) }
        [0, 4] => { $registers.A = 0 }
        [0, 5] => { $registers.A = $registers.A // (2 ** $registers.B) }
        [0, 6] => { $registers.A = $registers.A // (2 ** $registers.C) }
        [1, $x] => { $registers.B = $x | bits xor $registers.B }
        [2, $x] if $x <= 3 => { $registers.B = $x }
        [2, 4] => { $registers.B = $registers.A mod 8 }
        [2, 5] => { $registers.B = $registers.B mod 8 }
        [2, 6] => { $registers.B = $registers.C mod 8 }
        [3, $x] => { if $registers.A != 0 { $ptr = $x // 2 } }
        [4, _] => { $registers.B = $registers.B | bits xor $registers.C }
        [5, $x] if $x <= 3 => { $out = $out | append $x }
        [5, 4] => { $out = $out | append ($registers.A mod 8) }
        [5, 5] => { $out = $out | append ($registers.B mod 8) }
        [5, 6] => { $out = $out | append ($registers.C mod 8) }
        [6, $x] if $x <= 3 => { $registers.B = $registers.A // (2 ** $x) }
        [6, 4] => { $registers.B = 0 }
        [6, 5] => { $registers.B = $registers.A // (2 ** $registers.B) }
        [6, 6] => { $registers.B = $registers.A // (2 ** $registers.C) }
        [7, $x] if $x <= 3 => { $registers.A = $registers.A // (2 ** $x) }
        [7, 4] => { $registers.C = 0 }
        [7, 5] => { $registers.C = $registers.A // (2 ** $registers.B) }
        [7, 6] => { $registers.C = $registers.A // (2 ** $registers.C) }
      }
      if ($instruction.0 == 3) and ($registers.A) != 0 {
        continue
      }
      $ptr += 1
    }
    if $out == $program {
      print ($registers.A)
    }
  }
}
