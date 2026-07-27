import QtQuick
import QtQuick.Layouts
import Shadcn

// Official spinner-button: loading state inside a button -- Button.loading shows a leading Spinner and disables interaction.
ColumnLayout {
    spacing: Theme.space4                  // gap-4

    Button {
        Layout.alignment: Qt.AlignHCenter
        text: qsTr("Loading..."); size: Button.Sm; loading: true
    }
    Button {
        Layout.alignment: Qt.AlignHCenter
        text: qsTr("Please wait"); size: Button.Sm; variant: Button.Outline; loading: true
    }
    Button {
        Layout.alignment: Qt.AlignHCenter
        text: qsTr("Processing"); size: Button.Sm; variant: Button.Secondary; loading: true
    }
}
