#include "network.h"

#include <QPainter>
#include <QBrush>
#include <QDebug>


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

QImage Network::createImageFromTile(QByteArray data, int width, int height)
{
	QImage orig;
	if (!orig.loadFromData(data)) {
		qDebug() << "ERROR LOADING IMAGE";
	}

	// Create empty image with target size and format
	QImage large(width, height, QImage::Format_RGB32);

	// Fill image with tiles
	QPainter p;
	p.begin(&large);
	p.setBrush(QBrush(orig));
	p.drawRect(large.rect());
	p.end();

	return large;
}
