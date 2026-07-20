import QtQuick
import QtQuick.Layouts

// shadcn Field(纵向)—— Label(可带必填 *)+ 控件槽 + 可选描述(muted)+ 可选错误(destructive)。
// 对标 base-mira registry field.tsx 的 <Field>/<FieldLabel>/<FieldDescription>/<FieldError>,
// 视觉对齐 style-mira.css:.cn-field gap-2、描述 muted-foreground、错误 destructive、data-invalid→destructive。
//
// 结构等价说明:官方 Form 依赖 react-hook-form + zod;QML 无等价库,本组件仅做结构/视觉等价,
//   不接入 schema 校验。`error` 由使用方赋值(非空即错误态),`invalid` 供控件绑定其 invalid 属性。
//
// 用法:
//   FormField {
//       id: field
//       label: "Email"; required: true
//       description: "We'll never share it."
//       error: submitted && !valid ? "Enter a valid email." : ""
//       Input { Layout.fillWidth: true; invalid: field.invalid }
//   }
ColumnLayout {
    id: field

    property string label: ""
    property bool required: false                       // 必填:标签后加破坏色星号
    property string description: ""                     // 可选 muted 描述
    property string error: ""                           // 可选 destructive 错误文本(非空时显示)
    readonly property bool invalid: field.error !== ""  // 供控件 invalid 绑定
    default property alias controlData: slot.data       // 默认槽:置入 Input/Textarea/Select/…

    spacing: Theme.space2                               // .cn-field gap-2

    // ---- Label(+ 必填星号);invalid 时随 data-invalid 变破坏色 ----
    RowLayout {
        Layout.fillWidth: true
        spacing: 2
        visible: field.label !== ""
        Label {
            text: field.label
            color: field.invalid ? Theme.destructive : Theme.foreground
        }
        Label {
            text: "*"
            color: Theme.destructive
            visible: field.required
        }
    }

    // ---- 控件槽(使用方置入控件,并设 Layout.fillWidth)----
    ColumnLayout {
        id: slot
        Layout.fillWidth: true
        spacing: Theme.space2
    }

    // ---- 描述(muted)----
    FormDescription {
        Layout.fillWidth: true
        text: field.description
    }

    // ---- 错误(destructive,error 非空时显示)----
    FormMessage {
        Layout.fillWidth: true
        text: field.error
    }
}
