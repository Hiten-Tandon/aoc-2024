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
    regexp.compile(
      "(mul\\((\\d+),(\\d+)\\))|(do(n't)?\\(\\))",
      regexp.Options(False, False),
    )
    |> result.replace_error(utility.FileError),
  )
  {
    mul_pattern
    |> regexp.scan(data)
    |> list.fold(#(0, True), fn(acc, x) {
      let #(acc, should_add) = acc
      case x {
        regexp.Match(_, [_, Some(a), Some(b)]) if should_add -> {
          #(
            {
              a
              |> int.parse()
              |> result.unwrap(0)
            }
              * {
              b
              |> int.parse()
              |> result.unwrap(0)
            }
              + acc,
            should_add,
          )
        }
        regexp.Match("do", _) -> {
          #(acc, True)
        }
        regexp.Match("don't", _) -> {
          #(acc, False)
        }
        _ -> {
          #(acc, should_add)
        }
      }
    })
  }.0
  |> int.to_string()
  |> io.println()
  |> Ok()
}
