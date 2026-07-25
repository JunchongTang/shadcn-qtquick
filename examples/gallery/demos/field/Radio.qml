import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import Shadcn

// FieldSet + Legend(label 变体)+ 描述 + RadioGroup(三个横排 Field)。
// 单选项分散在各自 Field 中,用 ButtonGroup 维持互斥(组以属性传入,避免跨组件引用外层 id)。
FieldSet {
    width: 280        // max-w-xs
    C.ButtonGroup { id: plan }

    component PlanRow: Field {
        id: row
        property var group
        property alias label: lbl.text
        property alias checked: rb.checked
        orientation: Field.Horizontal
        RadioButton {
            id: rb
            C.ButtonGroup.group: row.group
            Layout.alignment: Qt.AlignVCenter
        }
        FieldLabel {
            id: lbl
            font.weight: Font.Normal
            Layout.alignment: Qt.AlignVCenter
        }
    }

    FieldLegend {
        variant: FieldLegend.Label
        text: qsTr("Subscription Plan")
    }
    FieldDescription { text: qsTr("Yearly and lifetime plans offer significant savings.") }

    RadioGroup {
        Layout.fillWidth: true
        PlanRow { group: plan; label: qsTr("Monthly ($9.99/month)"); checked: true }
        PlanRow { group: plan; label: qsTr("Yearly ($99.99/year)") }
        PlanRow { group: plan; label: qsTr("Lifetime ($299.99)") }
    }
}
