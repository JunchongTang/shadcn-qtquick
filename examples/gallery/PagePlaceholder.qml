import QtQuick
import QtQuick.Layouts
import Shadcn

// 未实现组件的占位页。
PageScaffold {
    description: "该组件尚未移植。此处将展示与 ui.shadcn.com 对齐的示例。"

    Preview {
        title: "Coming soon"
        RowLayout {
            spacing: 8
            Badge { text: "Not implemented"; variant: Badge.Outline }
        }
    }
}
