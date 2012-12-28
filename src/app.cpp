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

#include "app.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/system/InvokeTargetReply>
#include <QNetworkConfigurationManager>

#include "listmodel.h"
#include "qmlremoteimage.h"
#include "helper.h"

using namespace bb::cascades;

App::App()
{
    // Make our remote image view available as QML type
    qmlRegisterType<QmlRemoteImage>("de.kodira", 1, 0, "RemoteImageView");

    ListModel *patternModel = new ListModel(20, "patterns", "top", this);
    ListModel *colorModel = new ListModel(20, "colors", "top", this);

    QmlDocument *qml = QmlDocument::create("asset:///main.qml");
    qml->setContextProperty("listModel", patternModel);
    qml->setContextProperty("colorModel", colorModel);
    qml->setContextProperty("app", this);

    m_online = m_networkConfigManager.isOnline();

    connect(&m_homeScreen, SIGNAL(wallpaperFinished(const QUrl&, int)), this, SLOT(onWallpaperFinished(const QUrl&, int)));
    connect(&m_networkConfigManager, SIGNAL(onlineStateChanged(bool)), this, SLOT(onOnlineStateChanged(bool)));

    AbstractPane *root = qml->createRootObject<AbstractPane>();
    Application::instance()->setScene(root);
}

bb::cascades::Image App::bigImage()
{
	return m_bigImage;
}

void App::setBigImage(bb::cascades::Image image)
{
	m_bigImage = image;
	emit bigImageChanged();
}

void App::setWallpaper()
{
	qDebug() << "Saving as wallpaper";
	//QImage img;// = pattern->createQImage(768, 1280);

    // Everytime we switch wallpapers we switch between wallpaper_a.png and wallpaper_b.png as
    // filenames. We have to do this because the setWallpaper() API does not change wallpapers
    // if the path has not changed.
    QString filename;
    QFileInfo wallpaperA("./data/wallpaper_a.png");
    QFileInfo wallpaperB("./data/wallpaper_b.png");

    if (!wallpaperA.exists()) {
        filename = "wallpaper_a.png";
    } else if (!wallpaperB.exists()) {
        filename = "wallpaper_b.png";
    } else if (wallpaperA.lastModified() < wallpaperB.lastModified()) {
        filename = "wallpaper_a.png";
    } else {
        filename = "wallpaper_b.png";
    }

    QImage img = Helper::createImageFromTile(m_tile, 768, 1280);

	if (!img.save("./data/" + filename , "PNG")) {
		qDebug() << "ERROR: Cannot save wallpaper to storage";
		m_toast.setBody("ERROR: Could not save wallpaper storage");
		m_toast.show();
		return;
	}

    QUrl url("./data/" + filename);
	if (!m_homeScreen.setWallpaper(url)) {
		qDebug() << "ERROR: Cannot send request to change wallpaper";
		m_toast.setBody("ERROR: Cannot send request to change wallpaper");
		m_toast.show();
		return;
	}
}

void App::onWallpaperFinished(const QUrl &url, int result)
{
	Q_UNUSED(url);

	// We could also do the Toast in QML, but than we had to send a signal from C++ to QML
	// just to do that. This way it is much simpler.
	if (result == 0) {
		qDebug() << "INFO: Wallpaper successfully set";
		m_toast.setBody(tr("Wallpaper successfully set"));
	} else {
		qDebug() << "ERROR: Could not set wallpaper";
		m_toast.setBody("ERROR: Could not set wallpaper");
	}

	m_toast.show();
}

void App::shareWallpaper()
{
    QImage img = Helper::createImageFromTile(m_tile, 768, 1280);
    img.save("./data/wallpaper.png");

    QString path = QDir::current().absoluteFilePath("data/wallpaper.png");
    qDebug() << "ABS path:" << path;

    bb::system::InvokeRequest request;
    request.setMimeType("image/jpg");
    request.setAction("bb.action.SHARE");
    request.setUri(QUrl::fromLocalFile(path));
    //request.setMetadata(""); // map
    bb::system::InvokeTargetReply *reply = m_invokeManager.invoke(request);
    connect(reply, SIGNAL(finished()), this, SLOT(onInvokationFinished()));
}

void App::onInvokationFinished()
{
	qDebug() << "INFO: Invokation finished";

	bb::system::InvokeTargetReply *reply = (bb::system::InvokeTargetReply*) sender();

	if (reply->error() != 0) {
		m_toast.setBody("ERROR: " + QString::number(reply->error()));
		m_toast.show();
	}

	reply->deleteLater();
}

void App::createBigImage(QUrl url)
{
	qDebug() << "INFO: BigImage URL" << url;

	QNetworkReply *reply = Helper::networkManager()->get(QNetworkRequest(url));
	connect(reply, SIGNAL(finished()), this, SLOT(downloadFinished()));
}

void App::downloadFinished()
{
	qDebug() << "INFO: Big image downloaded";
	QNetworkReply *reply = (QNetworkReply*) sender();

	if (reply->error()) {
		qDebug() << "ERROR: Network error:" << reply->errorString();
	}

	m_tile.loadFromData(reply->readAll());

	QImage image = Helper::createImageFromTile(m_tile, 768, 1280);

	qDebug() << "INFO: Big image height" << image.height();
	qDebug() << "INFO: Big image width" << image.width();

	bb::cascades::Image cimg = Helper::convertImage(image);
	setBigImage(cimg);

	reply->deleteLater();
}

bool App::online()
{
	return m_online;
}

void App::onOnlineStateChanged(bool state)
{
	qDebug() << "XXX Online state changed. Now online: " << state;
	if (m_online != state) {
		m_online = state;
		emit onlineChanged();
	}
}
