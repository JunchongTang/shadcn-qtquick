#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QTimer>
#include <QImage>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // 无头验证:SHADCN_DARK 让 gallery 以暗色启动。
    engine.rootContext()->setContextProperty(
        "appStartDark", !qEnvironmentVariableIsEmpty("SHADCN_DARK"));

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
