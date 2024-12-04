use onig::Regex;
use utilities::{AocError, get_input};

pub fn main() -> Result<(), AocError> {
    let data = get_input(3)?;
    let regex = Regex::new(r"mul\(\d+,\d+\)").unwrap();
    let res = regex
        .find_iter(data.as_str())
        .filter_map(|(left, right)| data.as_str()[(left + 4)..(right - 1)].split_once(","))
        .map(|(a, b)| -> Result<u32, <u32 as std::str::FromStr>::Err> {
            Ok(a.parse::<u32>()? * b.parse::<u32>()?)
        })
        .filter_map(Result::ok)
        .sum::<u32>();
    println!("{res}");
    Ok(())
}
