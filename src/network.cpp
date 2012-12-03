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
