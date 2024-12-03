use itertools::Itertools;
use utilities::{AocError, get_input};

pub fn main() -> Result<(), AocError> {
    let res = get_input(2)?
        .lines()
        .map(str::split_ascii_whitespace)
        .map(|x| {
            x.map(str::parse::<i32>)
                .filter_map(Result::ok)
                .tuple_windows::<(_, _)>()
        })
        .map(|mut x| {
            x.clone().all(|(a, b)| (1..=3).contains(&(a - b)))
                || x.all(|(a, b)| (1..=3).contains(&(b - a)))
        })
        .filter(bool::clone)
        .count();
    println!("{res}");
    Ok(())
}
