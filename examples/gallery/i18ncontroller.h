#pragma once

#include <QObject>
#include <QString>
#include <QTranslator>
#include <memory>

class QQmlEngine;

// Runtime language switcher for the gallery example. Installs/removes a
// QTranslator loaded from the embedded qml_<lang>.qm resource (compiled from
// i18n/qml_zh_CN.ts) and retranslates the engine so qsTr()-bound QML text
// updates immediately, without restarting the app. Exposed to QML as the
// "i18n" context property (see main.cpp); "en" (the default) means no
// translator installed, i.e. the source English text.
class I18nController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString language READ language WRITE setLanguage NOTIFY languageChanged)

public:
    explicit I18nController(QQmlEngine *engine, QObject *parent = nullptr);

    QString language() const { return m_language; }
    void setLanguage(const QString &lang);

signals:
    void languageChanged();

private:
    QQmlEngine *m_engine;
    std::unique_ptr<QTranslator> m_translator;
    QString m_language = QStringLiteral("en");
};
