#pragma once

#include <QObject>
#include <QString>
#include <QtQml/qqmlregistration.h>

// 读取示例源码的辅助单例 —— QML 侧 XMLHttpRequest 读 qrc 不稳,改由 C++ 用 QFile 直读。
// 支持 qrc:/... 与 file:// 两种 URL,供文档站「Code」标签显示示例文件原文。
class SourceReader : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit SourceReader(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE QString read(const QString &url) const;

    // 把文本写入系统剪贴板(供示例卡「复制路径」按钮使用)。
    Q_INVOKABLE void copyToClipboard(const QString &text) const;
};
