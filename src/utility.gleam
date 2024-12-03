import envoy
import gleam/http/request
import gleam/httpc
import gleam/int
import gleam/result
import gleam/string
import simplifile

pub type AocError {
  HomeNotFound
  FileError
  HttpError
}

fn download_input(day: Int) -> Result(String, AocError) {
  use home <- result.try(
    envoy.get("HOME") |> result.replace_error(HomeNotFound),
  )

  use cookie <- result.try(
    home
    |> string.append("/.cache/aoc/SESSION_COOKIE.txt")
    |> simplifile.read()
    |> result.replace_error(FileError),
  )

  use req <- result.try(
    request.to(
      "https://adventofcode.com/2024/day/" <> int.to_string(day) <> "/input",
    )
    |> result.replace_error(HttpError),
  )

  req
  |> request.prepend_header("cookie", "session=" <> cookie)
  |> httpc.send()
  |> result.map(fn(x) {
    let dir = home <> "/.cache/aoc/2024/day" <> int.to_string(day)
    let _ = dir |> simplifile.create_directory_all()
    let _ = dir |> string.append("/input.txt") |> simplifile.write(x.body)
    x.body
  })
  |> result.replace_error(HttpError)
}

pub fn get_input(day: Int) -> Result(String, AocError) {
  use home <- result.try(
    envoy.get("HOME") |> result.replace_error(HomeNotFound),
  )

  simplifile.read(
    home <> "/.cache/aoc/2024/day" <> int.to_string(day) <> "/input.txt",
  )
  |> result.try_recover(fn(_) { download_input(day) })
}
