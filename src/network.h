#ifndef NETWORK_H
#define NETWORK_H

#include <QMutex>
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

};

#endif // ifndef NETWORK_H
