#ifndef LISTMODEL_H
#define LISTMODEL_H

#include <QObject>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>
#include <QTimer>
#include <bb/cascades/GroupDataModel>


class ListModel : public bb::cascades::GroupDataModel
{
    Q_OBJECT
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)
    Q_PROPERTY(int results READ results WRITE setResults NOTIFY resultsChanged)
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(QString category READ category WRITE setCategory NOTIFY categoryChanged)
    
public:
    explicit ListModel(QObject *parent = 0);
    ListModel(int results, QString type, QString category, QObject *parent = 0);
    bool loading();
    void setLoading(bool loading);
    int results();
    void setResults(int results);
    QString type();
    void setType(QString type);
    QString category();
    void setCategory(QString category);
    Q_INVOKABLE int length();
    
signals:
    void urlChanged();
    void loadingChanged();
    void resultsChanged();
    void typeChanged();
    void categoryChanged();
    
public slots:
    void loadData();
    void loadNextPage();
    void start();

private slots:
    void requestFinished();

private:
    void parseXml(QByteArray xmlData);
    QUrl m_url;
    bool m_loading;
    int m_page;
    int m_results;
    QString m_type;
    QString m_category;
    QString m_orderCol;
    bool m_started;
    void init();
    void fixSorting();
};

#endif // LISTMODEL_H
