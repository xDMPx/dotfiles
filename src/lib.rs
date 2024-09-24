#[cfg_attr(target_os = "windows", path = "windows.rs")]
#[cfg_attr(not(target_os = "windows"), path = "linux.rs")]
pub mod wallpaper;

use rand::prelude::*;
use serde::{Deserialize, Serialize};
#[cfg(target_os = "linux")]
use wallpaper::WallSetterProgram;

const COUNT_FACTOR: f64 = 1.001;

#[derive(Serialize, Deserialize, Debug)]
pub struct Wallpaper {
    pub file_name: String,
    pub count: usize,
}

#[derive(Debug, PartialEq)]
pub enum Option {
    Path(std::path::PathBuf),
    PrintState,
    PrintHelp,
    Interval(u64),
    #[cfg(target_os = "linux")]
    RestartSWWW,
    #[cfg(target_os = "linux")]
    Program(WallSetterProgram),
}

#[derive(Debug)]
pub enum Error {
    InvalidOption(String),
    InvalidOptionsStructure,
}

pub fn process_args() -> Result<Vec<Option>, Error> {
    let mut options = vec![];
    let mut args = std::env::args().skip(1).rev();

    if let Some(wallpapers_dir_path) = args.next() {
        let wallpapers_dir_path = std::path::PathBuf::from(wallpapers_dir_path);
        if !wallpapers_dir_path.is_dir() {
            return Err(Error::InvalidOptionsStructure);
        }
        options.push(Option::Path(wallpapers_dir_path));
        for arg in args {
            let arg = match arg.as_str() {
                "--print-state" => Ok(Option::PrintState),
                "--help" => Ok(Option::PrintState),
                s if s.starts_with("--interval=") => {
                    if let Some(suffix) = s.split_once('=').map(|(_, s)| s.parse::<u64>()) {
                        if let Ok(min) = suffix {
                            if min > 0 {
                                Ok(Option::Interval(min))
                            } else {
                                Err(Error::InvalidOption(arg))
                            }
                        } else {
                            Err(Error::InvalidOption(arg))
                        }
                    } else {
                        Err(Error::InvalidOption(arg))
                    }
                }
                #[cfg(target_os = "linux")]
                "--restart-swww" => Ok(Option::RestartSWWW),
                #[cfg(target_os = "linux")]
                s if s.starts_with("--program=") => {
                    if s.ends_with("swww") {
                        Ok(Option::Program(WallSetterProgram::SWWW))
                    } else if s.ends_with("plasma-apply-wallpaperimage") {
                        Ok(Option::Program(WallSetterProgram::PLASMA))
                    } else if s.ends_with("hyprpaper") {
                        #[allow(unused_mut, unused_assignments)]
                        let mut option = Err(Error::InvalidOption(arg));
                        #[cfg(all(feature = "hyprpaper", target_os = "linux"))]
                        {
                            option = Ok(Option::Program(WallSetterProgram::HYPRPAPER));
                        }
                        option
                    } else {
                        Err(Error::InvalidOption(arg))
                    }
                }
                _ => Err(Error::InvalidOption(arg)),
            };
            options.push(arg?);
        }
        return Ok(options);
    } else {
        return Err(Error::InvalidOptionsStructure);
    }
}

pub fn print_help() {
    println!("Usage: {} [OPTIONS] DIRECTORY", env!("CARGO_PKG_NAME"));
    println!("       {} --print-state DIRECTORY", env!("CARGO_PKG_NAME"));
    println!("Options:");
    println!("\t --help");
    println!("\t --interval=<u64>");
    println!("\t --restart-swww\t\t\t\tMight resolve the issue with out-of-sync and overlapping animations/wallpapers");
    #[cfg(not(all(feature = "hyprpaper", target_os = "linux")))]
    println!("\t --program=<swww|plasma-apply-wallpaperimage>");
    #[cfg(all(feature = "hyprpaper", target_os = "linux"))]
    println!("\t --program=<swww|hyprpaper|plasma-apply-wallpaperimage>");
}

pub fn pick_random_wallpaper(
    wallpaper_dir_path: &std::path::Path,
    wallpapers: &mut Vec<Wallpaper>,
) -> std::path::PathBuf {
    let total_count_w: f64 = wallpapers
        .iter()
        .map(|wallpaper| wallpaper.count as f64)
        .fold(0.0, |acc, count: f64| acc + COUNT_FACTOR.powf(-count));

    let rand_num = get_random_num(total_count_w);
    let mut cum_count_w: f64 = 0.0;
    let wallpaper = wallpapers
        .iter_mut()
        .skip_while(|wallpaper| {
            cum_count_w += COUNT_FACTOR.powf(-(wallpaper.count as f64));
            cum_count_w < rand_num
        })
        .next()
        .unwrap();

    wallpaper.count += 1;

    wallpaper_dir_path.join(wallpaper.file_name.clone())
}

pub fn sync_wallpapers(
    wallpaper_dir_path: &std::path::Path,
    mut wallpapers: Vec<Wallpaper>,
) -> Vec<Wallpaper> {
    let wallpapers_names = get_wallpapers_from_path(&wallpaper_dir_path);

    let old_wallpapers_names: Vec<&String> = wallpapers
        .iter()
        .map(|wallpaper_name| &wallpaper_name.file_name)
        .collect();

    let mut new_wallpapers: Vec<Wallpaper> = wallpapers_names
        .iter()
        .filter(|wallpaper_name| !old_wallpapers_names.contains(wallpaper_name))
        .map(|wallpaper_name| Wallpaper {
            file_name: wallpaper_name.clone(),
            count: 0,
        })
        .collect();
    new_wallpapers
        .iter()
        .for_each(|wallpaper| println!("Pushing {}", wallpaper.file_name));

    let removed_wallpapers_names: Vec<String> = old_wallpapers_names
        .iter()
        .filter(|wallpaper_name| !wallpapers_names.contains(wallpaper_name))
        .map(|wallpaper_name| wallpaper_name.to_string())
        .collect();

    for to_remove in removed_wallpapers_names {
        if let Some(to_remove_index) = wallpapers
            .iter()
            .position(|wallpaper| wallpaper.file_name == to_remove)
        {
            println!("Popping {}", to_remove);
            wallpapers.swap_remove(to_remove_index);
        }
    }

    wallpapers.append(&mut new_wallpapers);

    wallpapers
}

pub fn mean_centering_counts(mut wallpapers: Vec<Wallpaper>) -> Vec<Wallpaper> {
    if let Some(min) = wallpapers.iter().map(|w| w.count).min() {
        if min != 0 {
            wallpapers.iter_mut().for_each(|w| w.count -= min);
        }
    }
    wallpapers
}

pub fn get_wallpapers_from_path(wallpaper_dir_path: &std::path::Path) -> Vec<String> {
    let wallpapers = wallpaper_dir_path.read_dir().unwrap();
    let wallpapers = wallpapers.filter_map(|dir_entry| dir_entry.ok());
    let wallpapers = wallpapers.filter(|dir_entry| {
        dir_entry
            .path()
            .extension()
            .map_or(false, |extension| is_img_file(extension))
    });
    let wallpapers = wallpapers.map(|dir_entry| {
        dir_entry
            .file_name()
            .into_string()
            .expect(&format!("Invalid Unicode file name: {:?}", dir_entry))
    });

    wallpapers.collect()
}

fn is_img_file(extension: &std::ffi::OsStr) -> bool {
    match extension.to_string_lossy().to_string().as_str() {
        "jpg" => true,
        "jpeg" => true,
        "png" => true,
        "gif" => true,
        "pnm" => true,
        "tga" => true,
        "tiff" => true,
        "webp" => true,
        "bmp" => true,
        "farbfeld" => true,
        _ => false,
    }
}

fn get_random_num(to: f64) -> f64 {
    let mut rng = rand_hc::Hc128Rng::from_entropy();
    rng.gen_range(0.0..to)
}
