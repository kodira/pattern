#ifndef NETWORK_H
#define NETWORK_H

#include <QMutex>
#include <QImage>
#include <QtNetwork/QNetworkAccessManager>

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
	static QImage createImageFromTile(QByteArray data, int width, int height);

};

#endif // ifndef NETWORK_H
