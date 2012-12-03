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
