/*
 * Copyright (C) 2013 Cornelius Hald <cornelius.hald@kodira.de>
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
#include <bb/cascades/Invocation>
#include <bb/cascades/InvokeQuery>
#include <bb/device/DisplayInfo>
#include <QNetworkConfigurationManager>
#include <QUrl>

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

    // Set size of screen
    bb::device::DisplayInfo display;
    m_displayWidth = display.pixelSize().width();
    m_displayHeight = display.pixelSize().height();

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

bb::cascades::Image App::editImage()
{
	return m_editImage;
}

void App::setEditImage(bb::cascades::Image image)
{
	m_editImage = image;
	emit editImageChanged();
}

int App::displayWidth()
{
	return m_displayWidth;
}

int App::displayHeight()
{
	return m_displayHeight;
}

void App::setWallpaper()
{
	qDebug() << "Saving as wallpaper";
	m_toast.setBody(tr("Setting wallpaper"));
	m_toast.show();

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

	if (!m_bigImageCache.save("./data/" + filename , "PNG")) {
		qDebug() << "ERROR: Cannot save wallpaper to storage";
		m_toast.setBody("ERROR: Could not save wallpaper to storage");
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

	m_toast.cancel();
	m_toast.show();
}

void App::shareWallpaper()
{
    m_bigImageCache.save("./data/wallpaper.png");

    QUrl url = QUrl::fromLocalFile(QDir::current().absoluteFilePath("data/wallpaper.png"));

    Invocation *invocation = Invocation::create(
    		InvokeQuery::create().parent(this).mimeType("image/png").uri(url));

    QObject::connect(invocation, SIGNAL(armed()), this, SLOT(onShareInvocationArmed()));
    // Deletes the invocation once it finished
    QObject::connect(invocation, SIGNAL(finished()), invocation, SLOT(deleteLater()));
}

void App::onShareInvocationArmed()
{
	Invocation *invocation = qobject_cast<Invocation*>(sender());
	invocation->trigger("bb.action.SHARE");
}

// Should open the image in image editor. Currently not working.
void App::openWallpaper()
{
    m_bigImageCache.save("./data/wallpaper.png");

    QUrl url = QUrl::fromLocalFile(QDir::current().absoluteFilePath("data/wallpaper.png"));

    Invocation *invocation = Invocation::create(
    		InvokeQuery::create().parent(this).mimeType("image/png").uri(url));

    QObject::connect(invocation, SIGNAL(armed()), this, SLOT(onOpenInvocationArmed()));
    // Deletes the invocation once it finished
    QObject::connect(invocation, SIGNAL(finished()), invocation, SLOT(deleteLater()));
}

// Should open the image in image editor. Currently not working.
void App::onOpenInvocationArmed()
{
	Invocation *invocation = qobject_cast<Invocation*>(sender());
	invocation->trigger("bb.action.EDIT");
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

	QImage image = Helper::createImageFromTile(m_tile, m_displayWidth, m_displayHeight);
	m_bigImageCache = image;
	bb::cascades::Image cimg = Helper::convertImage(image);
	setBigImage(cimg);

	reply->deleteLater();
}

void App::resetEditImage()
{
	QImage image = Helper::createImageFromTile(m_tile, m_displayWidth, m_displayHeight);
	m_bigImageCache = image;
	bb::cascades::Image cimg = Helper::convertImage(image);
	setEditImage(cimg);
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

void App::applyEffect(QRectF rect, float zoom, float opacityA, float opacityB, float opacityC, float opacityD)
{
	QTime t;
	t.start();

	QRectF targetRect(0, 0, m_displayWidth, m_displayHeight);
	QRectF sourceRect(rect.x() / zoom, rect.y() / zoom, rect.width(), rect.height());

	QImage resultImage(QSize(m_displayWidth, m_displayHeight), QImage::Format_ARGB32_Premultiplied);

	QImage baseImage = Helper::createImageFromTile(m_tile, m_displayWidth, m_displayHeight);
	baseImage.convertToFormat(QImage::Format_ARGB32_Premultiplied);

	QDir imageDir = QDir::current();
	imageDir.cd("app/native/assets/images");

	QImage overlay1(imageDir.absoluteFilePath("effect1.png"));
	overlay1.convertToFormat(QImage::Format_ARGB32_Premultiplied);

	QImage overlay2(imageDir.absoluteFilePath("effect2.png"));
	overlay2.convertToFormat(QImage::Format_ARGB32_Premultiplied);

	QImage overlay3(imageDir.absoluteFilePath("effect3.png"));
	overlay3.convertToFormat(QImage::Format_ARGB32_Premultiplied);

	QImage overlay4(imageDir.absoluteFilePath("effect4.png"));
	overlay4.convertToFormat(QImage::Format_ARGB32_Premultiplied);

	qDebug() << "TIME: loading images:" << t.elapsed();
	t.restart();

	QPainter p(&resultImage);
	p.drawImage(targetRect, baseImage, sourceRect);
	p.setCompositionMode(QPainter::CompositionMode_SourceOver);
	p.setOpacity(opacityA);
	p.drawImage(0,0, overlay1);
	p.setOpacity(opacityB);
	p.drawImage(0,0, overlay2);
	p.setOpacity(opacityC);
	p.drawImage(0,0, overlay3);
	p.setOpacity(opacityD);
	p.drawImage(0,0, overlay4);
	p.end();

	qDebug() << "TIME drawing final image:" << t.elapsed();
	t.restart();

	m_bigImageCache = resultImage;

	bb::cascades::Image cimg = Helper::convertImage(resultImage);
	setBigImage(cimg);

	qDebug() << "TIME converting final image:" << t.elapsed();
	t.restart();
}
