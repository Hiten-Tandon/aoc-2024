import gleam/io
import gleam/result
import utility.{get_input}

pub fn main() {
  use input <- result.try(get_input(1))
  Ok(input |> io.println())
}
