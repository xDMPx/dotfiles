use core::ffi::c_void;
use std::os::windows::ffi::OsStrExt;

pub struct WallSetter {}

impl WallSetter {
    pub fn new() -> WallSetter {
        WallSetter {}
    }

    pub fn init(&self) {}

    pub fn set_wallpaper(&self, wallpaper: &std::path::Path) -> Result<(), std::io::Error> {
        self.set_wallpaper_windows(wallpaper)
    }

    pub fn is_running(&self) -> bool {
        let output = std::process::Command::new("tasklist")
            .arg("/fo")
            .arg("csv")
            .arg("/nh")
            .arg("/fi")
            .arg(format!("IMAGENAME eq {}.exe", env!("CARGO_PKG_NAME")))
            .output();

        output
            .map(|output| {
                output.status.success()
                    && std::string::String::from_utf8_lossy(&output.stdout)
                        .to_string()
                        .lines()
                        .count()
                        > 1
            })
            .unwrap_or(false)
    }

    pub fn kill(&self) -> Result<(), std::io::Error> {
        let pid = self.get_running_pid()?;
        let output = std::process::Command::new("taskkill")
            .arg("/f")
            .arg("/t")
            .arg("/PID")
            .arg(pid.to_string())
            .output()?;

        if !output.status.success() {
            eprintln!("{:?}", output.stderr);
            return Err(std::io::Error::new(
                std::io::ErrorKind::Other,
                format!("{:?}", output),
            ));
        }

        Ok(())
    }

    fn get_running_pid(&self) -> Result<usize, std::io::Error> {
        let output = std::process::Command::new("tasklist")
            .arg("/fo")
            .arg("csv")
            .arg("/nh")
            .arg("/fi")
            .arg(format!("IMAGENAME eq {}.exe", env!("CARGO_PKG_NAME")))
            .output()?;

        let pid: String;
        let out = std::string::String::from_utf8_lossy(&output.stdout);
        pid = out
            .lines()
            .next()
            .map(|line| {
                line.split_once("\",\"")
                    .map(|split| split.1)
                    .unwrap_or("")
                    .split_once("\"")
                    .map(|split| split.0)
                    .unwrap_or("")
            })
            .unwrap_or("")
            .to_string();

        if pid.is_empty() {
            return Err(std::io::Error::new(
                std::io::ErrorKind::Other,
                format!("tasklist invalid out: {}", out),
            ));
        }

        if let Ok(pid) = pid.parse() {
            Ok(pid)
        } else {
            return Err(std::io::Error::new(
                std::io::ErrorKind::Other,
                format!("tasklist invalid pid: {}", pid),
            ));
        }
    }

    fn set_wallpaper_windows(&self, wallpaper: &std::path::Path) -> Result<(), std::io::Error> {
        let path = std::ffi::OsStr::new(wallpaper)
            .encode_wide()
            .chain(Some(0))
            .collect::<Vec<u16>>();

        unsafe {
            windows_sys::Win32::UI::WindowsAndMessaging::SystemParametersInfoW(
                20,
                0,
                path.as_ptr() as *mut c_void,
                3,
            );
        }

        Ok(())
    }
}
