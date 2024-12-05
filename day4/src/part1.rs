use utilities::{AocError, get_input};
pub fn main() -> Result<(), AocError> {
    get_input(4)?
        .lines()
        .map(str::chars)
        .map(Iterator::collect::<Vec<_>>)
        .collect::<Vec<_>>();
    Ok(())
}
