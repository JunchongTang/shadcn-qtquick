#pragma once

#include <QObject>
#include <QString>
#include <QtQml/qqmlregistration.h>

// Helper singleton for reading example source — QML-side XMLHttpRequest reading qrc is unreliable, so C++ reads directly via QFile.
// Supports both qrc:/... and file:// URLs, for the docs site's "Code" tab to display the raw example file.
class SourceReader : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit SourceReader(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE QString read(const QString &url) const;

    // Write text to the system clipboard (used by the example card's "copy path" button).
    Q_INVOKABLE void copyToClipboard(const QString &text) const;
};
