import QtQuick
import QtQuick.Layouts
import Shadcn

// Responsive orientation: the web stacks on narrow screens and goes horizontal on wide ones; this library simplifies to horizontal (see Field.qml notes).
// FieldContent (label+description) on the left, control on the right; last row has two buttons horizontally.
FieldSet {
    width: 460        // max-w-lg

    FieldLegend { text: qsTr("Profile") }
    FieldDescription { text: qsTr("Fill in your profile information.") }

    FieldGroup {
        Field {
            orientation: Field.Responsive
            FieldContent {
                Layout.alignment: Qt.AlignTop
                FieldLabel { text: qsTr("Name") }
                FieldDescription { text: qsTr("Provide your full name for identification") }
            }
            Input {
                Layout.preferredWidth: 220
                Layout.alignment: Qt.AlignTop
                placeholderText: qsTr("Evil Rabbit")
            }
        }
        Field {
            orientation: Field.Responsive
            Button {
                text: qsTr("Submit")
                Layout.fillWidth: false
            }
            Button {
                text: qsTr("Cancel")
                variant: Button.Outline
                Layout.fillWidth: false
            }
            // Left-align: spacer pushes out the empty space on the right.
            Item { Layout.fillWidth: true }
        }
    }
}
