#include <QDebug>
#include <QImage>
#include <QFile>
#include <QByteArray>

#include <bb/system/InvokeManager>
#include <bb/system/InvokeRequest>
#include <bb/system/InvokeReply>
#include <unistd.h>

#include "network.h"
#include "pattern.h"


Pattern::Pattern(QObject *parent) :
    QObject(parent)
{
    m_loading = false;
	connect(this, SIGNAL(patternUrlChanged()), this, SLOT(loadListImage()));
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

bb::cascades::Image Pattern::listImage()
{
	return m_image;
}

void Pattern::setListImage(bb::cascades::Image image)
{
	m_image = image;
	emit listImageChanged();
}

bool Pattern::loading()
{
    return m_loading;
}

void Pattern::setLoading(bool loading)
{
    if (m_loading != loading) {
        m_loading = loading;
        emit loadingChanged();
    }
}

void Pattern::loadListImage()
{
	qDebug() << "INFO: Loading list image " << m_imageUrl;

	if (m_imageUrl.isEmpty()) {
		qDebug() << "WARN: ImageUrl is empty";
		return;
	}

    setLoading(true);
	QNetworkRequest request(m_imageUrl);
	QNetworkReply *reply = Network::manager()->get(request);

	connect(reply, SIGNAL(finished()), this, SLOT(listImageReceived()));
}

void Pattern::listImageReceived()
{
    setLoading(false);
	QNetworkReply *reply = (QNetworkReply*) sender();
	if (reply->error() != 0) {
		qDebug() << "ERROR: Could not load:" << m_imageUrl;
		reply->deleteLater();
		return;
	}

	m_rawImageData = reply->readAll();
	setListImage(createImage(768, 200));

	reply->deleteLater();
}

QImage Pattern::createQImage(int width, int height)
{
	QImage orig;
	if (!orig.loadFromData(m_rawImageData)) {
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

bb::cascades::Image Pattern::createImage(int width, int height)
{
	QImage image = createQImage(width, height);
    
    // Convert QImage into byte array to create a Cascades::Image
    QByteArray ba;
    QBuffer buffer(&ba);
    buffer.open(QIODevice::WriteOnly);
    image.save(&buffer, "PNG");

    return bb::cascades::Image(ba);
}

