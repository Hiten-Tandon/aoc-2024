import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import utility.{get_input}

fn has_even_digits(x: Int) -> Bool {
  int.to_string(x) |> string.length |> int.modulo(2) |> result.unwrap(0) == 0
}

fn get_first_half(x: Int) -> Int {
  let rep = int.to_string(x)
  rep
  |> string.slice(0, rep |> string.length |> int.divide(2) |> result.unwrap(0))
  |> int.parse
  |> result.unwrap(0)
}

fn get_second_half(x: Int) -> Int {
  let rep = int.to_string(x)
  let x = rep |> string.length |> int.divide(2) |> result.unwrap(0)
  rep
  |> string.slice(x, x)
  |> int.parse
  |> result.unwrap(0)
}

fn blink(
  stone: Int,
  times: Int,
  memo: Dict(#(Int, Int), Int),
) -> #(Dict(#(Int, Int), Int), Int) {
  case dict.get(memo, #(stone, times)), stone, times {
    Ok(x), _, _ -> #(memo, x)
    _, _, 0 -> #(memo, 1)
    _, 0, _ -> {
      let temp = blink(1, times - 1, memo)
      #(
        memo |> dict.insert(#(stone, times), temp.1) |> dict.merge(temp.0),
        temp.1,
      )
    }
    _, x, _ ->
      case has_even_digits(x) {
        True -> {
          let s1 = get_first_half(x)
          let s2 = get_second_half(x)
          let t1 = blink(s1, times - 1, memo)
          let memo = memo |> dict.merge(t1.0)
          let t2 = blink(s2, times - 1, memo)
          let memo = memo |> dict.merge(t2.0)
          #(memo |> dict.insert(#(x, times), t1.1 + t2.1), t1.1 + t2.1)
        }
        False -> {
          let temp = blink(stone * 2024, times - 1, memo)
          #(
            memo |> dict.insert(#(stone, times), temp.1) |> dict.merge(temp.0),
            temp.1,
          )
        }
      }
  }
}

pub fn main() {
  use data <- result.try(get_input(11))
  {
    data
    |> string.trim
    |> string.split(" ")
    |> list.map(int.parse)
    |> result.values
    |> list.fold(#(dict.new(), 0), fn(acc, x) {
      let temp = blink(x, 75, acc.0)
      #(temp.0, temp.1 + acc.1)
    })
  }.1
  |> int.to_string
  |> io.println
  |> Ok
}
