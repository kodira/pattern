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
    QNetworkReply *m_reply;
    void init();
    void fixSorting();
    void abortRequest();
};

#endif // LISTMODEL_H
