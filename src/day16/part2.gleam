import gleam/result
import utility.{get_input}

pub fn main() {
  use data <- result.try(get_input(16))
  data |> Ok
}
