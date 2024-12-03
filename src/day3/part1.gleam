import gleam/int
import gleam/io
import gleam/list
import gleam/option.{Some}
import gleam/regexp.{type Match}
import gleam/result
import utility.{get_input}

pub fn main() {
  use data <- result.try(get_input(3))
  use mul_pattern <- result.try(
    regexp.from_string("mul\\((\\d+),(\\d+)\\)")
    |> result.replace_error(utility.FileError),
  )
  mul_pattern
  |> regexp.scan(data)
  |> list.map(fn(x) {
    let assert regexp.Match(_, [Some(a), Some(b)]) = x
    { a |> int.parse() |> result.unwrap(0) }
    * { b |> int.parse() |> result.unwrap(0) }
  })
  |> list.fold(0, int.add)
  |> int.to_string()
  |> io.println()
  |> Ok()
}
