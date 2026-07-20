#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QStyleHints>
#include <QTimer>
#include <QImage>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // 让 Tab 在所有控件间移动(不止文本框)。macOS 默认按系统「键盘导航」开关设为
    // TabFocusTextControls(Tab 只走文本框);这里显式覆盖为 TabFocusAllControls,
    // 使键盘焦点导航跨平台一致、无需用户改系统设置(与浏览器/Web 应用行为一致)。
    app.styleHints()->setTabFocusBehavior(Qt::TabFocusAllControls);

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
