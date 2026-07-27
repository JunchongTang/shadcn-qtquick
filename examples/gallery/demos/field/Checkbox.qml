import QtQuick
import QtQuick.Layouts
import Shadcn

// FieldGroup: top FieldSet (label-variant legend + description + four horizontal checkboxes) + separator + checkbox with FieldContent.
FieldGroup {
    width: 300        // max-w-xs

    FieldSet {
        FieldLegend {
            variant: FieldLegend.Label
            text: qsTr("Show these items on the desktop")
        }
        FieldDescription { text: qsTr("Select the items you want to show on the desktop.") }

        // gap-3 checkbox group
        FieldGroup {
            spacing: Theme.space3

            component OptionRow: Field {
                orientation: Field.Horizontal
                property alias label: lbl.text
                property alias checked: cb.checked
                Checkbox {
                    id: cb
                    Layout.alignment: Qt.AlignVCenter
                }
                FieldLabel {
                    id: lbl
                    font.weight: Font.Normal
                    Layout.alignment: Qt.AlignVCenter
                }
            }

            OptionRow { label: qsTr("Hard disks"); checked: true }
            OptionRow { label: qsTr("External disks"); checked: true }
            OptionRow { label: qsTr("CDs, DVDs, and iPods") }
            OptionRow { label: qsTr("Connected servers") }
        }
    }

    FieldSeparator {}

    // Checkbox + FieldContent (label + description), items-start.
    Field {
        orientation: Field.Horizontal
        Checkbox {
            checked: true
            Layout.alignment: Qt.AlignTop
        }
        FieldContent {
            FieldLabel { text: qsTr("Sync Desktop & Documents folders") }
            FieldDescription {
                text: qsTr("Your Desktop & Documents folders are being synced with iCloud Drive. You can access them from other devices.")
            }
        }
    }
}
