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
    Q_PROPERTY(bb::cascades::Image listImage READ listImage NOTIFY listImageChanged)
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)

public:
    explicit Pattern(QObject *parent = 0);

    QString title();
    void setTitle(QString title);

    QString userName();
    void setUserName(QString userName);

    QUrl patternUrl();
    void setPatternUrl(QUrl imageUrl);
    
    bb::cascades::Image listImage();
    void setListImage(bb::cascades::Image image);
    
    bool loading();
    void setLoading(bool loading);

    QImage createQImage(int width, int height);
    Q_INVOKABLE bb::cascades::Image createImage(int width, int heigth);

signals:
    void titleChanged();
    void userNameChanged();
    void patternUrlChanged();
    void listImageChanged();
    void loadingChanged();
    
public slots:
	void loadListImage();
	void listImageReceived();

private:
    QString m_title;
    QString m_userName;
    QUrl m_imageUrl;
    bb::cascades::Image m_image;
    QByteArray m_rawImageData;
    bool m_loading;
    
};

Q_DECLARE_METATYPE(Pattern*)

#endif // PATTERN_H
