#ifndef QMLREMOTEIMAGE_H_
#define QMLREMOTEIMAGE_H_

#include <bb/cascades/ImageView>
#include <QUrl>

class QmlRemoteImage: public bb::cascades::ImageView {
	Q_OBJECT

	Q_PROPERTY (QUrl url READ url WRITE setUrl NOTIFY urlChanged)
	Q_PROPERTY (float loading READ loading NOTIFY loadingChanged)

public:
	QmlRemoteImage();
	virtual ~QmlRemoteImage();

	QUrl url() const;
	void setUrl(QUrl url);

	float loading() const;

private:
	QUrl m_url;
	float m_loading;
	QNetworkReply * m_reply;
	QImage m_tile;
	bb::cascades::Image convertImage(QImage image);
	void abortRequest();
	void updateImageFromTile();


signals:
	void urlChanged();
	void loadingChanged();

private slots:
	void downloadProgressChanged(qint64 bytes, qint64 total);
	void downloadFinished();
	void myPreferredWidthChanged(float);
	void myPreferredHeightChanged(float);



};

#endif /* QMLREMOTEIMAGE_H_ */
