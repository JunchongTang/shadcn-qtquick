#pragma once

#include <QJsonArray>
#include <QObject>
#include <QString>

class QQmlEngine;

// Batch hero-screenshot driver. Given a manifest (array of { name, demo|scene,
// contentWidth?, pad?, settleMs? }), it renders each entry in a real GPU window
// at the display's device pixel ratio (retina @2x) and saves <outDir>/<name>.png.
// Used by the gallery's SHADCN_SHOOT mode to generate the API-doc images.
class Shooter : public QObject
{
    Q_OBJECT
public:
    Shooter(QQmlEngine *engine, const QString &outDir, const QJsonArray &items,
            int settleMs = 700, QObject *parent = nullptr);

signals:
    void finished();

public slots:
    void start();

private:
    void shootNext();

    QQmlEngine *m_engine;
    QString m_outDir;
    QJsonArray m_items;
    int m_settleMs;
    int m_idx = -1;
    int m_ok = 0;
};
