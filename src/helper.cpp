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

#include "helper.h"

#include <QPainter>
#include <QBrush>
#include <QNetworkDiskCache>

QNetworkAccessManager* Helper::m_netManager = 0;
QNetworkDiskCache* Helper::m_diskCache = 0;

QNetworkAccessManager* Helper::networkManager()
{
	static QMutex mutex;
	if (!m_netManager) {
		mutex.lock();
		if (!m_netManager) {
			m_netManager = new QNetworkAccessManager();
			m_netManager->setCache(diskCache());
		}
		mutex.unlock();
	}
	return m_netManager;
}

QNetworkDiskCache* Helper::diskCache()
{
	static QMutex mutex;

	if (!m_diskCache) {
		mutex.lock();
		if (!m_diskCache) {
			m_diskCache = new QNetworkDiskCache();

			QDir dir = QDir::current();
			if (dir.cd("data")) {
				if (!dir.exists("Cache")) {
					dir.mkdir("Cache");
				}
				dir.cd("Cache");
				m_diskCache->setCacheDirectory(dir.absolutePath());
			}

			// Set sache size to about 50 MB which will use up to about 100 MB on disk. Not sure why...
			m_diskCache->setMaximumCacheSize(50 * 1024 * 1024);
		}
		mutex.unlock();
	}
	return m_diskCache;
}

QImage Helper::createImageFromTile(QByteArray tileData, int width, int height)
{
	QImage tile;
	tile.loadFromData(tileData);
	return createImageFromTile(tile, width, height);
}

QImage Helper::createImageFromTile(QImage tile, int width, int height)
{
	// Create empty image with target size and format
	QImage large(width, height, QImage::Format_RGB32);

	// Fill image with tiles
	QPainter p;
	p.begin(&large);
	p.setBrush(QBrush(tile));
	p.drawRect(large.rect());
	p.end();

	return large;
}

bb::cascades::Image Helper::convertImage(QImage image)
{
    // Convert QImage into byte array to create a Cascades::Image
	// Cascades Image only knows about PNG, JPG and GIF. We use JPG, because
	// PNG is about 10 times slower.
    QByteArray ba;
    QBuffer buffer(&ba);
    buffer.open(QIODevice::WriteOnly);
    image.save(&buffer, "JPG", -1);
    return bb::cascades::Image(ba);
}
