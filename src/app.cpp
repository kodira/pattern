#include "app.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/system/InvokeTargetReply>

#include "listmodel.h"

using namespace bb::cascades;

App::App()
{
    QmlDocument *qml = QmlDocument::create("asset:///main.qml");

    // Needed?
    qmlRegisterType<Pattern>();
    qmlRegisterType<ListModel>();

    ListModel *patternModel = new ListModel(20, "patterns", "top", this);
    ListModel *colorModel = new ListModel(20, "colors", "top", this);

    qml->setContextProperty("listModel", patternModel);
    qml->setContextProperty("colorModel", colorModel);
    qml->setContextProperty("app", this);

    AbstractPane *root = qml->createRootObject<AbstractPane>();

    connect(&m_homeScreen, SIGNAL(wallpaperFinished(const QUrl&, int)), this, SLOT(onWallpaperFinished(const QUrl&, int)));

    Application::instance()->setScene(root);
}

bb::cascades::Image App::bigImage()
{
	return m_bigImage;
}

void App::setBigImage(bb::cascades::Image image)
{
	m_bigImage = image;
	emit bigImageChanged();
}

void App::setWallpaper(Pattern *pattern)
{
	qDebug() << "Saving as wallpaper";
	QImage img = pattern->createQImage(768, 1280);

    // Everytime we switch wallpapers we switch between wallpaper_a.png and wallpaper_b.png as
    // filenames. We have to do this because the setWallpaper() API does not change wallpapers
    // if the path has not changed.
    QString filename;
    QFileInfo wallpaperA("./data/wallpaper_a.png");
    QFileInfo wallpaperB("./data/wallpaper_b.png");

    if (!wallpaperA.exists()) {
        filename = "wallpaper_a.png";
    } else if (!wallpaperB.exists()) {
        filename = "wallpaper_b.png";
    } else if (wallpaperA.lastModified() < wallpaperB.lastModified()) {
        filename = "wallpaper_a.png";
    } else {
        filename = "wallpaper_b.png";
    }

	if (!img.save("./data/" + filename , "PNG")) {
		qDebug() << "ERROR: Cannot save wallpaper to storage";
		m_toast.setBody("ERROR: Could not save wallpaper storage");
		m_toast.show();
		return;
	}

    QUrl url("./data/" + filename);
	if (!m_homeScreen.setWallpaper(url)) {
		qDebug() << "ERROR: Cannot send request to change wallpaper";
		m_toast.setBody("ERROR: Cannot send request to change wallpaper");
		m_toast.show();
		return;
	}
}

void App::onWallpaperFinished(const QUrl &url, int result)
{
	Q_UNUSED(url);

	// We could also do the Toast in QML, but than we had to send a signal from C++ to QML
	// just to do that. This way it is much simpler.
	if (result == 0) {
		qDebug() << "INFO: Wallpaper successfully set";
		m_toast.setBody(tr("Wallpaper successfully set"));
	} else {
		qDebug() << "ERROR: Could not set wallpaper";
		m_toast.setBody("ERROR: Could not set wallpaper");
	}

	m_toast.show();
}

void App::shareWallpaper(Pattern *pattern)
{
    QImage img = pattern->createQImage(768, 1280);
    img.save("./data/wallpaper.png");

    QString path = QDir::current().absoluteFilePath("data/wallpaper.png");
    qDebug() << "ABS path:" << path;

    bb::system::InvokeRequest request;
    request.setMimeType("image/png");
    request.setAction("bb.action.SHARE");
    request.setUri(QUrl::fromLocalFile(path));
    //request.setMetadata(""); // map
    bb::system::InvokeTargetReply *reply = m_invokeManager.invoke(request);
    connect(reply, SIGNAL(finished()), this, SLOT(onInvokationFinished()));
}

void App::onInvokationFinished()
{
	qDebug() << "INFO: Invokation finished";

	bb::system::InvokeTargetReply *reply = (bb::system::InvokeTargetReply*) sender();

	if (reply->error() != 0) {
		m_toast.setBody("ERROR: " + QString::number(reply->error()));
		m_toast.show();
	}

	reply->deleteLater();
}
