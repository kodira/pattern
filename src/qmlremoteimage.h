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

#ifndef QMLREMOTEIMAGE_H_
#define QMLREMOTEIMAGE_H_

#include <bb/cascades/ImageView>
#include <QUrl>
#include <QNetworkReply>

class QmlRemoteImage: public bb::cascades::ImageView {
	Q_OBJECT

	Q_PROPERTY (QUrl url READ url WRITE setUrl NOTIFY urlChanged)
	Q_PROPERTY (float loading READ loading NOTIFY loadingChanged)

public:
	QmlRemoteImage();
	virtual ~QmlRemoteImage();

	QUrl url() const;
	void setUrl(QUrl url);

	float loading() const;

private:
	QUrl m_url;
	float m_loading;
	QNetworkReply * m_reply;
	QImage m_tile;
	bb::cascades::Image convertImage(QImage image);
	void abortRequest();
	void updateImageFromTile();


signals:
	void urlChanged();
	void loadingChanged();

private slots:
	void downloadProgressChanged(qint64 bytes, qint64 total);
	void downloadFinished();
	void myPreferredWidthChanged(float);
	void myPreferredHeightChanged(float);



};

#endif /* QMLREMOTEIMAGE_H_ */
