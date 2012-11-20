#ifndef APP_H
#define APP_H

#include <QObject>
#include <QMutex>
#include <QtNetwork/QNetworkAccessManager>
#include <bb/cascades/Image>
#include <bb/cascades/Application>
#include <bb/platform/HomeScreen>
#include <bb/platform/WallpaperResult>
#include <bb/system/SystemToast>
#include <bb/system/InvokeManager>

#include "pattern.h"

/*!
 * @brief Application GUI object
 */
class App : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bb::cascades::Image bigImage READ bigImage WRITE setBigImage NOTIFY bigImageChanged)

public:
    App();
    bb::cascades::Image bigImage();
    void setBigImage(bb::cascades::Image image);
    Q_INVOKABLE void setWallpaper(Pattern* pattern);
    Q_INVOKABLE void shareWallpaper(Pattern* pattern);

private:
    bb::cascades::Image m_bigImage;
    bb::platform::HomeScreen m_homeScreen;
    bb::system::SystemToast m_toast;
    bb::system::InvokeManager m_invokeManager;

private slots:
	void onWallpaperFinished(const QUrl &url, int result);
	void onInvokationFinished();

signals:
    void bigImageChanged();





};

#endif // ifndef APP_H
