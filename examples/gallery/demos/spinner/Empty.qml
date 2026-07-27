import QtQuick
import QtQuick.Layouts
import Shadcn

// Official spinner-empty: loading state within an empty-state placeholder -- Spinner in the media icon slot.
// Note: official uses Empty / EmptyMedia / EmptyHeader components (not primitives of this library); approximated here with a centered column layout.
ColumnLayout {
    id: empty
    width: 360
    spacing: Theme.space4

    // EmptyMedia variant="icon": muted rounded box + centered icon.
    Rectangle {
        Layout.alignment: Qt.AlignHCenter
        implicitWidth: 40
        implicitHeight: 40
        radius: Theme.radiusLg
        color: Theme.muted
        border.width: 1
        border.color: Theme.border
        Spinner { anchors.centerIn: parent; size: 20 }
    }

    Text {
        Layout.alignment: Qt.AlignHCenter
        text: qsTr("Processing your request")
        color: Theme.foreground
        font.pixelSize: Theme.textSm
        font.weight: Font.Medium
        font.family: Theme.fontSans
    }
    Text {
        Layout.fillWidth: true
        Layout.topMargin: -Theme.space2
        text: qsTr("Please wait while we process your request. Do not refresh the page.")
        color: Theme.mutedForeground
        font.pixelSize: Theme.textSm
        font.family: Theme.fontSans
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
        horizontalAlignment: Text.AlignHCenter
    }

    Button {
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: Theme.space2
        text: qsTr("Cancel")
        size: Button.Sm
        variant: Button.Outline
    }
}
