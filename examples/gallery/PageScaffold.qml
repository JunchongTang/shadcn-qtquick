import QtQuick
import QtQuick.Layouts
import Shadcn

// Component detail page scaffold — large title + description + list of preview blocks. componentLabel is injected by the shell.
ColumnLayout {
    id: root
    property string componentLabel: ""
    property string description: ""
    default property alias body: previews.data

    width: parent ? parent.width : 720
    spacing: 20

    Text {
        text: root.componentLabel
        color: Theme.foreground
        font.pixelSize: 30
        font.weight: Font.DemiBold
    }
    Text {
        Layout.fillWidth: true
        visible: root.description !== ""
        text: root.description
        color: Theme.mutedForeground
        font.pixelSize: Theme.textSm
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }

    ColumnLayout {
        id: previews
        Layout.fillWidth: true
        Layout.topMargin: 8
        spacing: 28
    }
}
