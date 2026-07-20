import QtQuick

// shadcn Typography inline code —— rounded bg-muted px-[0.3rem] py-[0.2rem]
// font-mono text-sm font-semibold。rounded(Tailwind 默认) = 4px。
// px-[0.3rem] = 4.8px、py-[0.2rem] = 3.2px。
Rectangle {
    id: root
    property alias text: codeText.text

    implicitWidth: codeText.implicitWidth + 2 * 4.8
    implicitHeight: codeText.implicitHeight + 2 * 3.2
    radius: 4
    color: Theme.muted

    Text {
        id: codeText
        anchors.centerIn: parent
        color: Theme.foreground
        font.family: Theme.fontMono
        font.pixelSize: Theme.textSm
        font.weight: Font.DemiBold
        textFormat: Text.PlainText
    }
}
