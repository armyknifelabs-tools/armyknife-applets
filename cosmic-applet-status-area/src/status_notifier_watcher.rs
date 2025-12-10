// Copyright 2023 System76 <info@system76.com>
// SPDX-License-Identifier: GPL-3.0-only

use crate::subscriptions::status_notifier_watcher::server::create_service;

#[tokio::main]
pub async fn run() -> cosmic::iced::Result {
    let conn = zbus::Connection::session().await.unwrap();
    create_service(&conn).await;
    std::future::pending::<()>().await;
    Ok(())
}

// TODO: shut down when no clients for a while? or other test? avoid race?
