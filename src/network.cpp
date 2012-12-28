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

#include "network.h"

#include <QPainter>
#include <QBrush>
#include <QDebug>

/*
 * TODO: Rename to Helper
 */

QNetworkAccessManager* Network::m_netManager = 0;

QNetworkAccessManager* Network::manager()
{
	static QMutex mutex;
	if (!m_netManager) {
		mutex.lock();
		if (!m_netManager) {
			m_netManager = new QNetworkAccessManager();
		}
		mutex.unlock();
	}
	return m_netManager;
}

QImage Network::createImageFromTile(QByteArray tileData, int width, int height)
{
	QImage tile;
	tile.loadFromData(tileData);
	return createImageFromTile(tile, width, height);
}

QImage Network::createImageFromTile(QImage tile, int width, int height)
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

bb::cascades::Image Network::convertImage(QImage image)
{
    // Convert QImage into byte array to create a Cascades::Image
    QByteArray ba;
    QBuffer buffer(&ba);
    buffer.open(QIODevice::WriteOnly);
    image.save(&buffer, "PNG");

    return bb::cascades::Image(ba);
}
