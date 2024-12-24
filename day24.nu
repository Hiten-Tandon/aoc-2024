export def part1 [] {
  let data = open ~/.cache/aoc/2024/day24/input.txt | split row "\n\n"
  mut vals = $data | first | lines | each { split column ": " key val } | flatten | reduce --fold {} {|x, acc| $acc | merge {$x.key: ($x.val | into int)} }
  let connections = (
    $data 
      | last 
      | lines 
      | each { split column " -> " input output } 
      | flatten 
      | update input {$in | split column " " operand1 operator operand2} 
      | flatten 
      | flatten
  )

  for x in 0..500 {
    $vals = (
      $connections
      | where (($vals | get $it.operand1 -i) != null and ($vals | get $it.operand2 -i) != null and ($vals | get $it.output -i) == null)
      | reduce --fold $vals {|x, vals| 
        $vals | merge {
          $x.output: (match $x.operator {
            "AND" => (($vals | get $x.operand1) | bits and ($vals | get $x.operand2))
            "OR" => (($vals | get $x.operand1) | bits or ($vals | get $x.operand2))
            "XOR" => (($vals | get $x.operand1) | bits xor ($vals | get $x.operand2))
            _ => 0
          })
        }
      }
    );
  }
  let vals = $vals
  let res = (
    $vals 
      | columns 
      | filter { str starts-with z }
      | sort -nr
      | each {|x| $vals | get $x }
      | str join
      | into int --radix 2
  );
  wl-copy $res
  $res
}
