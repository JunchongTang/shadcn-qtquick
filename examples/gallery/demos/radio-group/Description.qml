import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import Shadcn

ColumnLayout {
    spacing: 12
    C.ButtonGroup { id: grp }

    component OptionRow: RowLayout {
        property alias label: l.text
        property alias description: d.text
        property alias value: rb.checked
        spacing: 12
        RadioButton { id: rb; C.ButtonGroup.group: grp; Layout.preferredWidth: 16; Layout.alignment: Qt.AlignTop }
        ColumnLayout {
            spacing: 2
            Label { id: l }
            Text {
                id: d
                color: Theme.mutedForeground
                font.pixelSize: Theme.textXs
                lineHeight: Theme.lineRelaxed
                lineHeightMode: Text.ProportionalHeight
            }
        }
    }

    OptionRow { label: "Default"; description: "Standard spacing for most use cases." }
    OptionRow { label: "Comfortable"; description: "More space between elements."; value: true }
    OptionRow { label: "Compact"; description: "Minimal spacing for dense layouts." }
}
