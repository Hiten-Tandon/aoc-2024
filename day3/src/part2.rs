use onig::Regex;
use utilities::{AocError, get_input};

pub fn main() -> Result<(), AocError> {
    let data = get_input(3)?;
    let regex = Regex::new(r"(mul\(\d+,\d+\))|(do(n't)?\(\))").unwrap();
    let res = regex
        .find_iter(data.as_str())
        .map(|(left, right)| &data.as_str()[left..right])
        .fold((0, true), |(acc, to_add), inp| match inp {
            "do()" => (acc, true),
            "don't()" => (acc, false),
            x if to_add => {
                let (left, right) = x[4..(x.len() - 1)].split_once(",").unwrap();
                (
                    left.parse::<u32>().unwrap() * right.parse::<u32>().unwrap() + acc,
                    true,
                )
            }
            _ => (acc, to_add),
        })
        .0;
    println!("{res}");
    Ok(())
}
