// Copyright 2023 System76 <info@system76.com>
// SPDX-License-Identifier: GPL-3.0-only

const VERSION: &str = env!("CARGO_PKG_VERSION");

fn main() -> cosmic::iced::Result {
    tracing_subscriber::fmt().with_env_filter("warn").init();
    let _ = tracing_log::LogTracer::init();

    let Some(applet) = std::env::args().next() else {
        return Ok(());
    };

    let start = applet.rfind('/').map_or(0, |v| v + 1);
    let cmd = &applet.as_str()[start..];

    tracing::info!("Starting `{cmd}` with version {VERSION}");

    match cmd {
        "armyknife-app-list" => cosmic_app_list::run(),
        "armyknife-applet-a11y" => cosmic_applet_a11y::run(),
        "armyknife-applet-audio" => cosmic_applet_audio::run(),
        "armyknife-applet-battery" => cosmic_applet_battery::run(),
        "armyknife-applet-bluetooth" => cosmic_applet_bluetooth::run(),
        "armyknife-applet-minimize" => cosmic_applet_minimize::run(),
        "armyknife-applet-network" => cosmic_applet_network::run(),
        "armyknife-applet-notifications" => cosmic_applet_notifications::run(),
        "armyknife-applet-power" => cosmic_applet_power::run(),
        "armyknife-applet-status-area" => cosmic_applet_status_area::run(),
        "armyknife-applet-tiling" => cosmic_applet_tiling::run(),
        "armyknife-applet-time" => cosmic_applet_time::run(),
        "armyknife-applet-workspaces" => cosmic_applet_workspaces::run(),
        "armyknife-applet-input-sources" => cosmic_applet_input_sources::run(),
        "armyknife-panel-button" => cosmic_panel_button::run(),
        _ => Ok(()),
    }
}
