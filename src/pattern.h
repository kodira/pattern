#ifndef PATTERN_H
#define PATTERN_H

#include <QObject>
#include <QMetaType>
#include <QUrl>
#include <bb/cascades/Image>

class Pattern : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString title READ title NOTIFY titleChanged)
    Q_PROPERTY(QString userName READ userName NOTIFY userNameChanged)
    Q_PROPERTY(QUrl patternUrl READ patternUrl NOTIFY patternUrlChanged)
    Q_PROPERTY(int rank READ rank NOTIFY rankChanged)
    Q_PROPERTY(int id READ id NOTIFY idChanged)

public:
    explicit Pattern(QObject *parent = 0);

    QString title();
    void setTitle(QString title);

    QString userName();
    void setUserName(QString userName);

    QUrl patternUrl();
    void setPatternUrl(QUrl imageUrl);

    int rank();
    void setRank(int rank);

    int id();
    void setId(int id);

signals:
    void titleChanged();
    void userNameChanged();
    void patternUrlChanged();
    void rankChanged();
    void idChanged();

private:
    QString m_title;
    QString m_userName;
    QUrl m_imageUrl;
    int m_rank;
    int m_id;
    
};

Q_DECLARE_METATYPE(Pattern*)

#endif // PATTERN_H
