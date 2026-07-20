import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import Shadcn

// 选择卡:把横排 Field 包进带边框的可点卡片(对标 FieldLabel 包裹 Field 的用法)。
// 选中:边框转 primary + 背景 primary/5;整卡可点。组以属性传入避免跨组件引用外层 id。
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

        // 横排 Field:FieldContent(标题+描述)在左,RadioButton 在右。
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
            text: "Compute Environment"
        }
        FieldDescription { text: "Select the compute environment for your cluster." }

        RadioGroup {
            Layout.fillWidth: true
            EnvCard {
                group: env
                title: "Kubernetes"
                description: "Run GPU workloads on a K8s cluster."
                checked: true
            }
            EnvCard {
                group: env
                title: "Virtual Machine"
                description: "Access a cluster to run GPU workloads."
            }
        }
    }
}
