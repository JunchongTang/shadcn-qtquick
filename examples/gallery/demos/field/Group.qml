import QtQuick
import QtQuick.Layouts
import Shadcn

// 两个 FieldSet 用 FieldSeparator 分隔;每组:FieldLabel 作小标题 + 描述 + 复选组。
FieldGroup {
    width: 300        // max-w-xs

    component OptionRow: Field {
        orientation: Field.Horizontal
        property alias label: lbl.text
        property alias checked: cb.checked
        property alias rowEnabled: cb.enabled
        Checkbox {
            id: cb
            Layout.alignment: Qt.AlignVCenter
        }
        FieldLabel {
            id: lbl
            font.weight: Font.Normal
            Layout.alignment: Qt.AlignVCenter
            opacity: cb.enabled ? 1.0 : 0.5
        }
    }

    FieldSet {
        FieldLabel { text: "Responses" }
        FieldDescription {
            text: "Get notified when ChatGPT responds to requests that take time, like research or image generation."
        }
        FieldGroup {
            spacing: Theme.space3
            OptionRow { label: "Push notifications"; checked: true; rowEnabled: false }
        }
    }

    FieldSeparator {}

    FieldSet {
        FieldLabel { text: "Tasks" }
        FieldDescription {
            text: "Get notified when tasks you've created have updates."
        }
        FieldGroup {
            spacing: Theme.space3
            OptionRow { label: "Push notifications" }
            OptionRow { label: "Email notifications" }
        }
    }
}
