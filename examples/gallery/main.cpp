#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QGuiApplication>
#include <QHostAddress>
#include <QHttpServer>
#include <QHttpServerResponder>
#include <QJsonArray>
#include <QJsonDocument>
#include <QMimeDatabase>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QStyleHints>
#include <QTcpServer>
#include <QTimer>
#include <QUrl>
#include <QImage>
#include <QtWebView/QtWebView>

#include "shooter.h"

// Serve the generated API docs over local HTTP. QtWebView's native backend
// (WKWebView on macOS) silently refuses file:// URLs, so a tiny loopback
// server is used instead. Returns the base URL (http://127.0.0.1:<port>/) or
// an empty string when the docs are absent / the server can't bind.
static QString startDocsServer(QObject *parent, const QString &docsDir)
{
    if (docsDir.isEmpty() || !QFileInfo::exists(docsDir + QStringLiteral("/shadcn-qmlmodule.html")))
        return {};

    const QString root = QFileInfo(docsDir).absoluteFilePath();
    auto *server = new QHttpServer(parent);
    server->setMissingHandler(server, [root](const QHttpServerRequest &req, QHttpServerResponder &responder) {
        QString path = req.url().path();
        if (path.isEmpty() || path == QStringLiteral("/"))
            path = QStringLiteral("/shadcn-qmlmodule.html");
        // Resolve within the docs root and reject any traversal outside it.
        const QString full = QDir::cleanPath(root + QStringLiteral("/") + path);
        if (!full.startsWith(root)) {
            responder.write(QHttpServerResponder::StatusCode::Forbidden);
            return;
        }
        QFile f(full);
        if (!f.open(QIODevice::ReadOnly)) {
            responder.write(QHttpServerResponder::StatusCode::NotFound);
            return;
        }
        const QByteArray data = f.readAll();
        const QByteArray mime = QMimeDatabase().mimeTypeForFile(full).name().toUtf8();
        responder.write(data, mime);
    });

    auto *tcp = new QTcpServer(server);
    if (!tcp->listen(QHostAddress::LocalHost) || !server->bind(tcp)) {
        delete server;
        return {};
    }
    return QStringLiteral("http://127.0.0.1:%1/").arg(tcp->serverPort());
}

// Absolute path of the generated API docs, baked in by CMake (overridable at
// runtime via the SHADCN_DOCS_DIR environment variable).
#ifndef SHADCN_DOCS_DIR
#define SHADCN_DOCS_DIR ""
#endif

int main(int argc, char *argv[])
{
    // Force QtWebView's native backend (WKWebView on macOS) before any Qt init.
    // The default prefers the WebEngine backend, which fails to load when Qt
    // WebEngine isn't installed and then reports "No WebView plug-in found!"
    // instead of falling back. Must be set before QGuiApplication. (Overridable.)
    if (qEnvironmentVariableIsEmpty("QT_WEBVIEW_PLUGIN"))
        qputenv("QT_WEBVIEW_PLUGIN", "native");

    QGuiApplication app(argc, argv);

    // 让 Tab 在所有控件间移动(不止文本框)。macOS 默认按系统「键盘导航」开关设为
    // TabFocusTextControls(Tab 只走文本框);这里显式覆盖为 TabFocusAllControls,
    // 使键盘焦点导航跨平台一致、无需用户改系统设置(与浏览器/Web 应用行为一致)。
    app.styleHints()->setTabFocusBehavior(Qt::TabFocusAllControls);

    QQmlApplicationEngine engine;

    // Batch hero-screenshot mode: SHADCN_SHOOT=<outdir> renders every entry of
    // the shots manifest (:/shots/shots.json) to <outdir>/<name>.png and quits.
    // Run windowed (real GPU) so shadows/blur render; see docs/build-images.sh.
    if (const QByteArray shootDir = qgetenv("SHADCN_SHOOT"); !shootDir.isEmpty()) {
        QFile mf(QStringLiteral(":/shots/shots.json"));
        if (!mf.open(QIODevice::ReadOnly)) {
            qFatal("cannot open :/shots/shots.json");
            return -1;
        }
        const QJsonArray items = QJsonDocument::fromJson(mf.readAll()).array();
        auto *shooter = new Shooter(&engine, QString::fromUtf8(shootDir), items);
        QObject::connect(shooter, &Shooter::finished, &app, &QCoreApplication::quit);
        QTimer::singleShot(0, shooter, &Shooter::start);
        return app.exec();
    }

    // Native web view (WKWebView on macOS) for the embedded API-docs pane.
    QtWebView::initialize();

    // 无头验证:SHADCN_DARK 让 gallery 以暗色启动。
    engine.rootContext()->setContextProperty(
        "appStartDark", !qEnvironmentVariableIsEmpty("SHADCN_DARK"));

    // Locate the generated API docs (docs/build-docs.sh output) and serve them
    // over local HTTP. The gallery's per-component "API" tab loads pages from
    // this base URL; it is empty (tab hidden) when the docs are absent.
    const QString docsDir = qEnvironmentVariable("SHADCN_DOCS_DIR", QStringLiteral(SHADCN_DOCS_DIR));
    engine.rootContext()->setContextProperty("docsBaseUrl", startDocsServer(&app, docsDir));

    engine.loadFromModule("Gallery", "Gallery");
    if (engine.rootObjects().isEmpty())
        return -1;

    // 无头截图:SHADCN_SHOT=<png> 加载后抓根窗口并退出(offscreen 软件后端可渲染 Controls/Rectangle)。
    if (const QByteArray shot = qgetenv("SHADCN_SHOT"); !shot.isEmpty()) {
        auto *win = qobject_cast<QQuickWindow *>(engine.rootObjects().constFirst());
        QTimer::singleShot(900, &app, [win, shot]() {
            if (win)
                win->grabWindow().save(QString::fromUtf8(shot));
            QCoreApplication::quit();
        });
    }

    return app.exec();
}
