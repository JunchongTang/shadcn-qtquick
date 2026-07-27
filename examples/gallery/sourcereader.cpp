#include "sourcereader.h"

#include <QClipboard>
#include <QFile>
#include <QGuiApplication>
#include <QUrl>

QString SourceReader::read(const QString &url) const
{
    QString path = url;
    const QUrl parsed(url);
    if (parsed.scheme() == QLatin1String("qrc"))
        path = QLatin1Char(':') + parsed.path();       // qrc:/demos/x.qml -> :/demos/x.qml
    else if (parsed.isLocalFile())
        path = parsed.toLocalFile();

    QFile file(path);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return QStringLiteral("// Failed to read source: %1").arg(url);
    return QString::fromUtf8(file.readAll());
}

void SourceReader::copyToClipboard(const QString &text) const
{
    if (QClipboard *cb = QGuiApplication::clipboard())
        cb->setText(text);
}
