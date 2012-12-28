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

#include <QDebug>
#include <QImage>
#include <QFile>
#include <QByteArray>

#include <bb/system/InvokeManager>
#include <bb/system/InvokeRequest>
#include <bb/system/InvokeReply>
#include <unistd.h>

#include "helper.h"
#include "pattern.h"


Pattern::Pattern(QObject *parent) :
    QObject(parent)
{
}

QString Pattern::title()
{
    return m_title;
}

void Pattern::setTitle(QString title)
{
    if (m_title != title ) {
        m_title = title;
        emit titleChanged();
    }
}

QString Pattern::userName()
{
    return m_userName;
}

void Pattern::setUserName(QString userName)
{
    if (m_userName != userName) {
        m_userName = userName;
        emit userNameChanged();
    }
}

QUrl Pattern::patternUrl()
{
    return m_imageUrl;
}

void Pattern::setPatternUrl(QUrl imageUrl)
{
    if (m_imageUrl != imageUrl) {
        m_imageUrl = imageUrl;
        emit patternUrlChanged();
    }
}

int Pattern::rank()
{
	return m_rank;
}

void Pattern::setRank(int rank)
{
	if (m_rank != rank) {
		m_rank = rank;
		emit rankChanged();
	}
}

int Pattern::id()
{
	return m_id;
}

void Pattern::setId(int id)
{
	if (m_id != id) {
		m_id = id;
		emit idChanged();
	}
}
