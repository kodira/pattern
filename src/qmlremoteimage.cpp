#include "qmlremoteimage.h"
#include "network.h"

QmlRemoteImage::QmlRemoteImage() {
	m_loading = 0;
	m_reply = 0;

	connect(this, SIGNAL(preferredWidthChanged(float)), this, SLOT(myPreferredWidthChanged(float)));
	connect(this, SIGNAL(preferredHeightChanged(float)), this, SLOT(myPreferredHeightChanged(float)));
}

QmlRemoteImage::~QmlRemoteImage() {
	abortRequest();
}

QUrl QmlRemoteImage::url() const
{
	return m_url;
}

void QmlRemoteImage::setUrl(QUrl url)
{
	if (m_url != url) {
		m_url = url;
		m_loading = 0;

		if (url.isEmpty()) {
			abortRequest();
			setImageSource(QUrl());
		} else {
			m_reply = Network::manager()->get(QNetworkRequest(url));
			connect(m_reply, SIGNAL(finished()), this, SLOT(downloadFinished()));
			connect(m_reply, SIGNAL(downloadProgress(qint64,qint64)), this, SLOT(downloadProgressChanged(qint64,qint64)));
		}

		emit urlChanged();
	}
}

float QmlRemoteImage::loading() const
{
	return m_loading;
}

void QmlRemoteImage::downloadProgressChanged(qint64 bytes, qint64 total)
{
	m_loading =  float(bytes)/float(total);
	emit loadingChanged();
}

void QmlRemoteImage::downloadFinished()
{
	if (m_reply) {
		m_tile.loadFromData(m_reply->readAll());
		updateImageFromTile();

		m_reply->deleteLater();
		m_reply = 0;
	}
}

void QmlRemoteImage::updateImageFromTile()
{
	if (preferredWidth() > 0 && preferredHeight() > 0) {
		QImage image = Network::createImageFromTile(m_tile, preferredWidth(), preferredHeight());
		setImage(Network::convertImage(image));
	}
}

void QmlRemoteImage::abortRequest()
{
	if (m_reply) {
		m_reply->abort();
		m_reply->deleteLater();
		m_reply = 0;
	}
}

void QmlRemoteImage::myPreferredWidthChanged(float width)
{
	qDebug() << "Layout, myPreferredWidthChanged " << width;

	if (width > 0 && preferredHeight() > 0) {
		updateImageFromTile();
	}
}

void QmlRemoteImage::myPreferredHeightChanged(float height)
{
	qDebug() << "Layout, myPreferredHeightChanged " << height;

	if (height > 0 && preferredWidth() > 0) {
		updateImageFromTile();
	}
}
