import QtQuick
import QtQuick.Layouts
import Shadcn

// 响应式朝向:前端窄屏堆叠、宽屏横排;本库简化为横排(见 Field.qml 说明)。
// FieldContent(标签+描述)在左,控件在右;末行两个按钮横排。
FieldSet {
    width: 460        // max-w-lg

    FieldLegend { text: "Profile" }
    FieldDescription { text: "Fill in your profile information." }

    FieldGroup {
        Field {
            orientation: Field.Responsive
            FieldContent {
                Layout.alignment: Qt.AlignTop
                FieldLabel { text: "Name" }
                FieldDescription { text: "Provide your full name for identification" }
            }
            Input {
                Layout.preferredWidth: 220
                Layout.alignment: Qt.AlignTop
                placeholderText: "Evil Rabbit"
            }
        }
        Field {
            orientation: Field.Responsive
            Button {
                text: "Submit"
                Layout.fillWidth: false
            }
            Button {
                text: "Cancel"
                variant: Button.Outline
                Layout.fillWidth: false
            }
            // 左对齐:占位撑开右侧空白。
            Item { Layout.fillWidth: true }
        }
    }
}
