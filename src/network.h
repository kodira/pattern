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

#ifndef NETWORK_H
#define NETWORK_H

#include <QMutex>
#include <QImage>
#include <QtNetwork/QNetworkAccessManager>
#include <bb/cascades/Image>

/*!
 * @brief Network singleton
 */
class Network
{

private:
	Network();
	Network(const Network &); // hide copy constructor
	Network& operator=(const Network &); // hide assign op
	static QNetworkAccessManager* m_netManager;

public:
	static QNetworkAccessManager* manager();
	static QImage createImageFromTile(QByteArray tileData, int width, int height);
	static QImage createImageFromTile(QImage tile, int width, int height);
	static bb::cascades::Image convertImage(QImage image);

};

#endif // ifndef NETWORK_H
