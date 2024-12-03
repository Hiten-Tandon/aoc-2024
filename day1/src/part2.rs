use itertools::Itertools;
use utilities::{AocError, get_input};
pub fn main() -> Result<(), AocError> {
    let (l, r): (Vec<_>, Vec<_>) = get_input(1)?
        .lines()
        .filter_map(|l| {
            l.split_ascii_whitespace()
                .map(str::parse::<u32>)
                .filter_map(Result::ok)
                .collect_tuple()
        })
        .unzip();
    let r_cts = r.into_iter().counts();
    let res: u32 = l
        .into_iter()
        .map(|x| x * r_cts.get(&x).copied().unwrap_or_default() as u32)
        .sum();
    println!("{res}");
    Ok(())
}
