#include "i18ncontroller.h"

#include <QCoreApplication>
#include <QQmlEngine>

I18nController::I18nController(QQmlEngine *engine, QObject *parent)
    : QObject(parent), m_engine(engine)
{
}

void I18nController::setLanguage(const QString &lang)
{
    if (lang == m_language)
        return;

    if (m_translator) {
        QCoreApplication::removeTranslator(m_translator.get());
        m_translator.reset();
    }

    if (lang != QLatin1String("en")) {
        auto translator = std::make_unique<QTranslator>();
        if (translator->load(QStringLiteral(":/i18n/qml_%1.qm").arg(lang))) {
            QCoreApplication::installTranslator(translator.get());
            m_translator = std::move(translator);
        }
    }

    m_language = lang;
    emit languageChanged();
    // Force every qsTr()-bound QML binding to re-evaluate against the newly
    // installed (or removed) translator.
    m_engine->retranslate();
}
