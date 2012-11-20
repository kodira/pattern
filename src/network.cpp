#include "network.h"

QNetworkAccessManager* Network::m_netManager = 0;

QNetworkAccessManager* Network::manager()
{
	static QMutex mutex;
	if (!m_netManager) {
		mutex.lock();
		if (!m_netManager) {
			m_netManager = new QNetworkAccessManager();
		}
		mutex.unlock();
	}
	return m_netManager;
}

