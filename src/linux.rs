pub struct WallSetter {
    child: Option<std::process::Child>,
    program: WallSetterProgram,
    restart_swww: bool,
    #[cfg(feature = "hyprpaper")]
    hyprpaper: Option<std::process::Child>,
}

#[derive(Debug, PartialEq, Clone, Copy)]
pub enum WallSetterProgram {
    SWWW,
    PLASMA,
    #[cfg(feature = "hyprpaper")]
    HYPRPAPER,
}

impl WallSetter {
    pub fn new() -> WallSetter {
        WallSetter {
            child: None,
            program: WallSetterProgram::SWWW,
            restart_swww: false,
            #[cfg(feature = "hyprpaper")]
            hyprpaper: None,
        }
    }

    pub fn set_program(&mut self, program: WallSetterProgram) {
        self.program = program;
    }

    pub fn set_restart_swww(&mut self, restart_swww: bool) {
        self.restart_swww = restart_swww;
    }

    pub fn init(&mut self) {
        if self.is_running_under_wayland() {
            match &self.program {
                WallSetterProgram::SWWW => {
                    self.swww_init().unwrap();
                }
                WallSetterProgram::PLASMA => {}
                #[cfg(feature = "hyprpaper")]
                WallSetterProgram::HYPRPAPER => {
                    self.hyprpaper_init().unwrap();
                }
            }
        }
    }

    pub fn set_wallpaper(&mut self, wallpaper: &std::path::Path) -> Result<(), std::io::Error> {
        if self.is_running_under_wayland() {
            match &self.program {
                WallSetterProgram::SWWW => {
                    self.set_wallpaper_wayland(wallpaper)?;
                    if self.restart_swww {
                        std::thread::sleep(std::time::Duration::from_secs(10));
                        self.kill_swww_daemon()?;
                        self.swww_daemon_init()?;
                    }
                }
                WallSetterProgram::PLASMA => {
                    self.set_wallpaper_wayland(wallpaper)?;
                }
                #[cfg(feature = "hyprpaper")]
                WallSetterProgram::HYPRPAPER => {
                    self.hyprpaper_preload(wallpaper)?;
                    self.hyprpaper_set_wallpaper(wallpaper)?;
                    std::thread::sleep(std::time::Duration::from_secs(2));
                    self.hyprpaper_unload_all()?;
                }
            }
        } else {
            self.set_wallpaper_x11(wallpaper)?;
        }

        Ok(())
    }

    pub fn is_running(&self) -> bool {
        let output = std::process::Command::new("pgrep")
            .arg("-c")
            .arg(env!("CARGO_PKG_NAME"))
            .output();

        output
            .map(|output| {
                output.status.success()
                    && std::string::String::from_utf8(output.stdout)
                        .map(|x| !x.starts_with("1"))
                        .unwrap_or(false)
            })
            .unwrap_or(false)
    }

    pub fn kill(&mut self) -> Result<(), std::io::Error> {
        let output = std::process::Command::new("pkill")
            .arg("-o")
            .arg(env!("CARGO_PKG_NAME"))
            .output()?;

        if !output.status.success() {
            eprintln!("{:?}", output.stderr);
            return Err(std::io::Error::new(
                std::io::ErrorKind::Other,
                format!("{:?}", output),
            ));
        }

        match &self.program {
            WallSetterProgram::SWWW => {
                self.kill_swww_daemon()?;
            }
            WallSetterProgram::PLASMA => {}
            #[cfg(feature = "hyprpaper")]
            WallSetterProgram::HYPRPAPER => {
                self.kill_hyprpaper()?;
            }
        }

        Ok(())
    }

    fn kill_swww_daemon(&mut self) -> Result<(), std::io::Error> {
        if let Some(child) = self.child.as_mut() {
            child.kill()?;
            child.wait()?;
            self.child = None;
        } else {
            let output = std::process::Command::new("pkill")
                .arg("swww-daemon")
                .output()?;

            if !output.status.success() {
                eprintln!("{:?}", output.stderr);
                return Err(std::io::Error::new(
                    std::io::ErrorKind::Other,
                    format!("{:?}", output),
                ));
            }
        }

        Ok(())
    }

    fn swww_init(&mut self) -> Result<(), std::io::Error> {
        let output = std::process::Command::new("pgrep")
            .arg("-f")
            .arg("swww")
            .output()?;

        if !output.status.success() {
            self.swww_daemon_init()?;
        }

        Ok(())
    }

    fn swww_daemon_init(&mut self) -> Result<(), std::io::Error> {
        std::thread::sleep(std::time::Duration::from_secs(2));
        self.child = Some(std::process::Command::new("swww-daemon").spawn()?);
        std::thread::sleep(std::time::Duration::from_secs(2));

        Ok(())
    }

    fn swww_set_wallpaper(&self, wallpaper: &std::path::Path) -> Result<(), std::io::Error> {
        std::process::Command::new("swww")
            .arg("img")
            .arg(wallpaper)
            .spawn()?
            .wait()?;

        Ok(())
    }

    #[cfg(feature = "hyprpaper")]
    fn hyprpaper_init(&mut self) -> Result<(), std::io::Error> {
        let output = std::process::Command::new("pgrep")
            .arg("hyprpaper")
            .output()?;

        if !output.status.success() {
            self.hyprpaper = Some(std::process::Command::new("hyprpaper").spawn()?);
            std::thread::sleep(std::time::Duration::from_secs(2));
        }

        Ok(())
    }

    #[cfg(feature = "hyprpaper")]
    fn kill_hyprpaper(&mut self) -> Result<(), std::io::Error> {
        if let Some(hyprpaper) = self.hyprpaper.as_mut() {
            hyprpaper.kill()?;
            hyprpaper.wait()?;
            self.hyprpaper = None;
        } else {
            let output = std::process::Command::new("pkill")
                .arg("hyprpaper")
                .output()?;

            if !output.status.success() {
                eprintln!("{:?}", output.stderr);
                return Err(std::io::Error::new(
                    std::io::ErrorKind::Other,
                    format!("{:?}", output),
                ));
            }
        }

        Ok(())
    }

    #[cfg(feature = "hyprpaper")]
    fn hyprpaper_preload(&self, wallpaper: &std::path::Path) -> Result<(), std::io::Error> {
        std::process::Command::new("hyprctl")
            .arg("hyprpaper")
            .arg("preload")
            .arg(wallpaper)
            .spawn()?
            .wait()?;

        println!("preload: {:?}", wallpaper);

        Ok(())
    }

    #[cfg(feature = "hyprpaper")]
    fn hyprpaper_unload_all(&self) -> Result<(), std::io::Error> {
        std::process::Command::new("hyprctl")
            .arg("hyprpaper")
            .arg("unload")
            .arg("all")
            .spawn()?
            .wait()?;

        Ok(())
    }

    #[cfg(feature = "hyprpaper")]
    fn hyprpaper_set_wallpaper(&self, wallpaper: &std::path::Path) -> Result<(), std::io::Error> {
        std::process::Command::new("hyprctl")
            .arg("hyprpaper")
            .arg("wallpaper")
            .arg(format!(",{}", wallpaper.display()))
            .spawn()?
            .wait()?;

        Ok(())
    }

    fn plasma_set_wallpaper(&self, wallpaper: &std::path::Path) -> Result<(), std::io::Error> {
        std::process::Command::new("plasma-apply-wallpaperimage")
            .arg(wallpaper)
            .spawn()?
            .wait()?;

        Ok(())
    }

    fn is_running_under_wayland(&self) -> bool {
        let wayland = std::env::var("WAYLAND_DISPLAY");
        wayland.is_ok()
    }

    fn set_wallpaper_wayland(&self, wallpaper: &std::path::Path) -> Result<(), std::io::Error> {
        match &self.program {
            WallSetterProgram::SWWW => {
                self.swww_set_wallpaper(wallpaper)?;
            }
            WallSetterProgram::PLASMA => {
                self.plasma_set_wallpaper(wallpaper)?;
            }
            #[cfg(feature = "hyprpaper")]
            WallSetterProgram::HYPRPAPER => {
                self.hyprpaper_set_wallpaper(wallpaper)?;
            }
        }

        Ok(())
    }

    fn set_wallpaper_x11(&self, wallpaper: &std::path::Path) -> Result<(), std::io::Error> {
        std::process::Command::new("feh")
            .arg("--bg-fill")
            .arg(wallpaper)
            .spawn()?
            .wait()?;

        Ok(())
    }
}
