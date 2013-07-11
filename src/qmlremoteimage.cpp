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

#include "qmlremoteimage.h"
#include "helper.h"

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

		abortRequest();

		if (url.isEmpty()) {
			resetImageSource();
		} else {
			QNetworkRequest request = QNetworkRequest(url);
			request.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::PreferCache);
			m_reply = Helper::networkManager()->get(request);

			if (m_reply->error() == QNetworkReply::NoError) {
				connect(m_reply, SIGNAL(finished()), this, SLOT(downloadFinished()));
				connect(m_reply, SIGNAL(downloadProgress(qint64,qint64)), this, SLOT(downloadProgressChanged(qint64,qint64)));
			} else {
				m_reply->deleteLater();
				m_reply = 0;
			}
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
		if (m_reply->error() == QNetworkReply::NoError) {
			m_tile.loadFromData(m_reply->readAll());
			updateImageFromTile();
		}
		m_reply->deleteLater();
		m_reply = 0;
	}
}

void QmlRemoteImage::updateImageFromTile()
{
	if (preferredWidth() > 0 && preferredHeight() > 0) {
		QImage image = Helper::createImageFromTile(m_tile, preferredWidth(), preferredHeight());
		setImage(Helper::convertImage(image));
	}
}

void QmlRemoteImage::abortRequest()
{
	if (m_reply) {
		m_reply->disconnect();
		m_reply->abort();
		m_reply->deleteLater();
		m_reply = 0;
	}
}

void QmlRemoteImage::myPreferredWidthChanged(float width)
{
	if (width > 0 && isPreferredHeightSet()) {
		updateImageFromTile();
	}
}

void QmlRemoteImage::myPreferredHeightChanged(float height)
{
	if (height > 0 && isPreferredWidthSet()) {
		updateImageFromTile();
	}
}
