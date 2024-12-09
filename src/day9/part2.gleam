import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/yielder
import utility.{get_input}

type Block {
  File(filename: Int, start: Int, end: Int)
  Empty(start: Int, end: Int)
}

fn replace_with_first_that_can_fit(
  emptys: List(Block),
  file: Block,
) -> #(List(Block), Block) {
  case emptys, file {
    [], _ -> #([], file)
    [Empty(_, e_end), ..], File(_, f_start, _) if f_start < e_end -> #([], file)
    [Empty(e_start, e_end), ..rest], File(filename, f_start, f_end)
      if f_end - f_start < e_end - e_start
    -> {
      #(
        [Empty(e_start + f_end - f_start, e_end), ..rest],
        File(filename, e_start, e_start + f_end - f_start),
      )
    }
    [Empty(e_start, e_end), ..rest], File(filename, f_start, f_end)
      if f_end - f_start == e_end - e_start
    -> {
      #(rest, File(filename, e_start, e_end))
    }
    [head, ..rest], file -> {
      let #(rest, file) = replace_with_first_that_can_fit(rest, file)
      #([head, ..rest], file)
    }
  }
}

pub fn main() {
  use data <- result.try(get_input(9))
  let #(files, emptys, _): #(List(Block), List(Block), Int) =
    data
    |> string.trim
    |> string.to_graphemes
    |> list.map(int.parse)
    |> result.values
    |> list.index_fold(#([], [], 0), fn(acc, x, i) {
      case i % 2 {
        0 if x != 0 -> #(
          [File(i / 2, acc.2, acc.2 + x), ..acc.0],
          acc.1,
          acc.2 + x,
        )
        1 if x != 0 -> #(acc.0, [Empty(acc.2, acc.2 + x), ..acc.1], acc.2 + x)
        _ -> acc
      }
    })
  let emptys = list.reverse(emptys)
  {
    files
    |> list.fold(
      #(emptys, []),
      fn(acc: #(List(Block), List(Block)), file: Block) -> #(
        List(Block),
        List(Block),
      ) {
        let temp = replace_with_first_that_can_fit(acc.0, file)
        #(temp.0, [temp.1, ..acc.1])
      },
    )
  }.1
  |> list.map(fn(x) {
    case x {
      File(fname, start, end) ->
        yielder.range(start, end - 1)
        |> yielder.map(fn(i) { i * fname })
        |> yielder.fold(0, int.add)
      _ -> panic as "How did this happen?"
    }
  })
  |> list.fold(0, int.add)
  |> int.to_string
  |> io.println
  |> Ok()
}
