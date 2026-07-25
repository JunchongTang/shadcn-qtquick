#include "shooter.h"

#include <QDir>
#include <QImage>
#include <QJsonObject>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQuickItem>
#include <QQuickView>
#include <QTimer>
#include <QUrl>
#include <QtGlobal>

Shooter::Shooter(QQmlEngine *engine, const QString &outDir, const QJsonArray &items,
                 int settleMs, QObject *parent)
    : QObject(parent), m_engine(engine), m_outDir(outDir), m_items(items), m_settleMs(settleMs)
{
    QDir().mkpath(outDir);
}

void Shooter::start()
{
    qInfo().noquote() << QStringLiteral("Shooting %1 hero images -> %2").arg(m_items.size()).arg(m_outDir);
    shootNext();
}

void Shooter::shootNext()
{
    ++m_idx;
    if (m_idx >= m_items.size()) {
        qInfo().noquote() << QStringLiteral("Done: %1/%2 saved.").arg(m_ok).arg(m_items.size());
        emit finished();
        return;
    }

    const QJsonObject item = m_items.at(m_idx).toObject();
    const QString name = item.value(QStringLiteral("name")).toString();
    const QString scene = item.value(QStringLiteral("scene")).toString(); // full-scene qrc url
    const QString demo = item.value(QStringLiteral("demo")).toString();    // demo to wrap on a surface
    const int cw = item.value(QStringLiteral("contentWidth")).toInt(0);
    const int ch = item.value(QStringLiteral("contentHeight")).toInt(0);
    const int pad = item.value(QStringLiteral("pad")).toInt(24);
    const int settle = item.value(QStringLiteral("settleMs")).toInt(m_settleMs);

    auto *view = new QQuickView(m_engine, nullptr);
    view->setResizeMode(QQuickView::SizeViewToRootObject);

    if (!scene.isEmpty()) {
        view->setSource(QUrl(scene));
    } else {
        // Wrap a demo on a themed surface via the generic DemoFrame; the demo URL
        // and forced content width travel through root-context properties.
        m_engine->rootContext()->setContextProperty(QStringLiteral("shotSource"), demo);
        m_engine->rootContext()->setContextProperty(QStringLiteral("shotContentWidth"), cw);
        m_engine->rootContext()->setContextProperty(QStringLiteral("shotContentHeight"), ch);
        view->setSource(QUrl(QStringLiteral("qrc:/shots/DemoFrame.qml")));
    }

    if (view->status() == QQuickView::Error) {
        qWarning().noquote() << "shot ERROR" << name << view->errors();
        view->deleteLater();
        shootNext();
        return;
    }

    view->show();

    QTimer::singleShot(settle, this, [this, view, name]() {
        const QImage img = view->grabWindow();
        const QString path = m_outDir + QStringLiteral("/") + name + QStringLiteral(".png");
        if (img.isNull() || !img.save(path)) {
            qWarning().noquote() << "FAILED" << name;
        } else {
            ++m_ok;
            qInfo().noquote() << QStringLiteral("  %1  %2x%3").arg(name, -22).arg(img.width()).arg(img.height());
        }
        view->close();
        view->deleteLater();
        shootNext();
    });
}
