import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import Shadcn

// Choice card: wrap a horizontal Field into a bordered clickable card (mirrors FieldLabel wrapping a Field).
// Checked: border turns primary + background primary/5; whole card is clickable. Group passed in as a property to avoid cross-component references to an outer id.
FieldGroup {
    width: 300        // max-w-xs
    C.ButtonGroup { id: env }

    // FieldLabel(has field): rounded-md border p-2 + has-data-checked:bg-primary/5
    component EnvCard: Rectangle {
        id: cardRoot
        property var group
        property alias title: title.text
        property alias description: desc.text
        property alias checked: rb.checked
        Layout.fillWidth: true
        implicitHeight: row.implicitHeight + Theme.space2 * 2   // p-2
        radius: Theme.radiusMd
        color: rb.checked ? Theme.alpha(Theme.primary, 0.05) : "transparent"
        border.width: 1
        border.color: rb.checked ? Theme.primary : Theme.border

        // Horizontal Field: FieldContent (title+description) on the left, RadioButton on the right.
        RowLayout {
            id: row
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: Theme.space2
            spacing: Theme.space2

            FieldContent {
                FieldTitle { id: title }
                FieldDescription { id: desc }
            }
            RadioButton {
                id: rb
                C.ButtonGroup.group: cardRoot.group
                Layout.alignment: Qt.AlignVCenter
            }
        }
        TapHandler { onTapped: rb.toggle() }
    }

    FieldSet {
        FieldLegend {
            variant: FieldLegend.Label
            text: qsTr("Compute Environment")
        }
        FieldDescription { text: qsTr("Select the compute environment for your cluster.") }

        RadioGroup {
            Layout.fillWidth: true
            EnvCard {
                group: env
                title: qsTr("Kubernetes")
                description: qsTr("Run GPU workloads on a K8s cluster.")
                checked: true
            }
            EnvCard {
                group: env
                title: qsTr("Virtual Machine")
                description: qsTr("Access a cluster to run GPU workloads.")
            }
        }
    }
}
