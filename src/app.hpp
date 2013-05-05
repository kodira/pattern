/*
 * Copyright (C) 2012 Cornelius Hald <cornelius.hald@kodira.de>
 *
 * This file is part of Pattern.
 *
 * Pattern is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Pattern is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Pattern. If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef APP_H
#define APP_H

#include <QObject>
#include <QMutex>
#include <QtNetwork/QNetworkAccessManager>
#include <bb/cascades/Image>
#include <bb/cascades/Application>
#include <bb/platform/HomeScreen>
#include <bb/platform/WallpaperResult>
#include <bb/system/SystemToast>
#include <bb/system/InvokeManager>

#include "pattern.h"

/*!
 * @brief Application GUI object
 */
class App : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bb::cascades::Image bigImage READ bigImage WRITE setBigImage NOTIFY bigImageChanged)
    Q_PROPERTY(bool online READ online NOTIFY onlineChanged)

public:
    App();
    bb::cascades::Image bigImage();
    void setBigImage(bb::cascades::Image image);
    bool online();
    Q_INVOKABLE void setWallpaper();
    Q_INVOKABLE void shareWallpaper();
    Q_INVOKABLE void openWallpaper();
    Q_INVOKABLE void createBigImage(QUrl url);
    Q_INVOKABLE void applyEffect(QRectF rect, float zoom, float opacityA, float opacityB, float opacityC, float opacityD);

private:
    QImage m_tile;
    bool m_online;
    bb::cascades::Image m_bigImage;
    QImage m_bigImageCache; // Same as m_bigImage but as QImage
    bb::platform::HomeScreen m_homeScreen;
    bb::system::SystemToast m_toast;
    bb::system::InvokeManager m_invokeManager;
    QNetworkConfigurationManager m_networkConfigManager;

private slots:
	void onWallpaperFinished(const QUrl &url, int result);
	void onShareInvocationArmed();
	void onOpenInvocationArmed();
	void downloadFinished();
	void onOnlineStateChanged(bool state);

signals:
    void bigImageChanged();
    void onlineChanged();





};

#endif // ifndef APP_H
