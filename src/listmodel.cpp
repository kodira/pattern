#include <QDebug>
#include <QXmlStreamReader>
#include <QtNetwork/QNetworkConfigurationManager>
#include <QStringList>

#include "pattern.h"
#include "network.h"
#include "listmodel.h"

ListModel::ListModel(QObject *parent) :
	bb::cascades::GroupDataModel(parent)
{
    m_results = 20;
    m_type = "patterns";
    m_category = "top";
    init();   
}

ListModel::ListModel(int results, QString type, QString category, QObject *parent) :
    bb::cascades::GroupDataModel(parent), m_results(results), m_type(type), m_category(category)
{
    init();
}

void ListModel::init()
{
    m_page = 0;
    m_loading = false;
    m_started = false;

    // TODO: Disable sorting
    this->setSortingKeys(QStringList() << "title" << "userName");
    this->setGrouping(bb::cascades::ItemGrouping::None);
    
    connect(this, SIGNAL(resultsChanged()), this, SLOT(loadData()));
    connect(this, SIGNAL(pageChanged()), this, SLOT(loadData()));
    connect(this, SIGNAL(typeChanged()), this, SLOT(loadData()));
    connect(this, SIGNAL(categoryChanged()), this, SLOT(loadData()));
}

QUrl ListModel::url()
{
    return m_url;
}

void ListModel::setUrl(QUrl url)
{
    if (m_url != url) {
        m_url = url;
        emit urlChanged();
    }
}

bool ListModel::loading()
{
	return m_loading;
}

void ListModel::setLoading(bool loading)
{
	if (m_loading != loading) {
		m_loading = loading;
		emit loadingChanged();
	}
}

int ListModel::page()
{
    return m_page;
}

void ListModel::setPage(int page)
{
    if (m_page != page) {
        m_page = page;
        emit pageChanged();
    }
}

int ListModel::results()
{
    return m_results;
}

void ListModel::setResults(int results)
{
    if (m_results != results) {
        m_results = results;
        emit resultsChanged();
    }
}

QString ListModel::type()
{
    return m_type;
}

void ListModel::setType(QString type)
{
    if (m_type != type) {
        m_type = type;
        // TODO: Now we load data two times because 2 signals are emitted. Not good.
        setPage(0);
        emit typeChanged();
    }
}

QString ListModel::category()
{
    return m_category;
}

void ListModel::setCategory(QString category)
{
    if (m_category != category) {
        m_category = category;
        // TODO: Now we load data two times because 2 signals are emitted. Not good.
        setPage(0);
        emit categoryChanged();
    }
}

void ListModel::loadData()
{
    if (!m_started) {
        qDebug() << "WARN: Not yet started. Doing nothing.";
        return;
    }
    
	setLoading(true);
    this->clear();
	qDebug() << "*** Doing network request ***";
	QNetworkConfigurationManager m;
	qDebug() << "Online:" << m.isOnline();
    QNetworkRequest request;
    QString url = QString("http://www.colourlovers.com/api/%1/%2/?numberResults=%3&resultOffset=%4")
            .arg(m_type)
            .arg(m_category)
            .arg(m_results)
            .arg(m_results * m_page);
    
    request.setUrl(url);
    QNetworkReply *reply = Network::manager()->get(request);
    connect(reply, SIGNAL(finished()), this, SLOT(requestFinished()));
}

void ListModel::requestFinished()
{
	QNetworkReply *reply = (QNetworkReply*) sender();
    qDebug() << "Reply finished";
    if (reply->error() != QNetworkReply::NoError) {
        qDebug() << "Network error";
        // TODO: Emit error and to show note on screen
        reply->deleteLater();
        return;
    }

    QByteArray xmlData = reply->readAll();
    setLoading(false);
    parseXml(xmlData);

    reply->deleteLater();
}

void ListModel::parseXml(QByteArray xmlData)
{
    //qDebug() << xmlData;
    QXmlStreamReader xml;
    xml.addData(xmlData);

    Pattern *pattern = 0;

    while (!xml.atEnd()) {
        if (xml.readNextStartElement()) {

            if (xml.name() == "pattern" || xml.name() == "color") {
                qDebug() << "Create new pattern";
                pattern = new Pattern(this);
                qDebug() << "################# INSERT ####################";
                this->insert(pattern);
                continue;
            }

            if (xml.name() == "title") {
                pattern->setTitle(xml.readElementText());
                qDebug() << "Title:" << pattern->title();
                continue;
            }

            if (xml.name() == "userName") {
                pattern->setUserName(xml.readElementText());
                qDebug() << "UserName:" << pattern->userName();
                continue;
            }

            if (xml.name() == "imageUrl") {
                pattern->setPatternUrl(QUrl(xml.readElementText()));
                qDebug() << "ImageUrl:" << pattern->patternUrl();
                continue;
            }
        } else {
            // Use this to read through the whole xml even if there are not start elements anymore
            xml.readNext();
        }
    }

    if (xml.hasError()) {
        qDebug() << "Error parsing XML:" << xml.errorString();
    }
}

void ListModel::loadNextPage()
{
    m_page++;
    emit pageChanged();
}

void ListModel::loadPreviousPage()
{
    if (m_page > 0) {
        m_page--;
        emit pageChanged();
    }
}

void ListModel::start()
{
    m_started = true;
    loadData();
}
