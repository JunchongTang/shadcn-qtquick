import QtQuick

// shadcn Kbd —— 键盘按键提示。bg-muted、h-5、min-w-5、rounded、px-1、text-[0.625rem] 中等。
Rectangle {
    id: control
    property alias text: label.text

    implicitHeight: 20                                   // h-5
    implicitWidth: Math.max(20, label.implicitWidth + 8) // min-w-5 / px-1
    radius: 4                                            // rounded-xs 近似
    color: Theme.muted

    Text {
        id: label
        anchors.centerIn: parent
        color: Theme.mutedForeground
        font.pixelSize: 10                              // text-[0.625rem]
        font.weight: Font.Medium
        font.family: Theme.fontSans
    }
}
