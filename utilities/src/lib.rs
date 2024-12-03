use std::{
    fs,
    io::{self, Read},
};

use reqwest::{blocking::Client, header::COOKIE};

#[derive(Debug)]
pub enum AocError {
    SessionError,
    FileError(io::Error),
    RequestError(reqwest::Error),
    ParsingError(io::Error),
}

pub fn get_input(day: u8) -> Result<String, AocError> {
    let home = std::env::var("HOME").unwrap_or_default();
    fs::read_to_string(format!("{home}/.cache/aoc/2024/day{day}")).or_else(|_| download_data(day))
}

fn download_data(day: u8) -> Result<String, AocError> {
    let client = Client::new();
    let home = std::env::var("HOME").unwrap_or_default();
    let mut data = String::new();
    client
        .execute(
            client
                .get(format!("https://www.adventofcode.com/2024/day/{day}/input"))
                .header(
                    COOKIE,
                    format!(
                        "session={}",
                        fs::read_to_string(format!("{home}/.cache/aoc/SESSION_COOKIE.txt",))
                            .map_err(|_| AocError::SessionError)?
                    ),
                )
                .build()
                .map_err(AocError::RequestError)?,
        )
        .map_err(AocError::RequestError)?
        .read_to_string(&mut data)
        .map_err(AocError::ParsingError)?;

    fs::create_dir_all(format!("{home}/.cache/aoc/2024/day{day}")).map_err(AocError::FileError)?;
    fs::write(format!("{home}/.cache/aoc/2024/day{day}"), data.as_str())
        .map_err(AocError::FileError)?;
    Ok(data)
}
