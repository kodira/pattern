#include "qmlremoteimage.h"
#include "network.h"

QmlRemoteImage::QmlRemoteImage() {
	// TODO Auto-generated constructor stub

}

QmlRemoteImage::~QmlRemoteImage() {
	// TODO Auto-generated destructor stub
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
		QNetworkReply * reply = Network::manager()->get(QNetworkRequest(url));
		connect(reply, SIGNAL(finished()), this, SLOT(downloadFinished()));
		connect(reply, SIGNAL(downloadProgress(qint64,qint64)), this, SLOT(downloadProgressChanged(qint64,qint64)));
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

bb::cascades::Image QmlRemoteImage::convertImage(QImage image, int width, int height)
{
    // Convert QImage into byte array to create a Cascades::Image
    QByteArray ba;
    QBuffer buffer(&ba);
    buffer.open(QIODevice::WriteOnly);
    image.save(&buffer, "PNG");

    return bb::cascades::Image(ba);
}

void QmlRemoteImage::downloadFinished()
{
	QNetworkReply * reply = qobject_cast<QNetworkReply*>(sender());

	QImage image = Network::createImageFromTile(reply->readAll(), preferredWidth(), preferredHeight());
	setImage(convertImage(image, preferredWidth(), preferredHeight()));

	reply->deleteLater();
}
