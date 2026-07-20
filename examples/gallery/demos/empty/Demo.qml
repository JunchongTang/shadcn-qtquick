import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 empty-demo:圆底图标 + 标题 + 描述 + 两个动作按钮(行) + Learn More 链接。
Empty {
    EmptyHeader {
        EmptyMedia {
            variant: EmptyMedia.Icon
            iconName: "folder-code"
        }
        EmptyTitle { text: "No Projects Yet" }
        EmptyDescription {
            text: "You haven't created any projects yet. Get started by creating your first project."
        }
    }

    EmptyContent {
        // flex-row justify-center gap-2 —— 两个按钮并排居中。
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Theme.space2
            Button { text: "Create Project" }
            Button { text: "Import Project"; variant: Button.Outline }
        }
    }

    // Learn More 链接(Empty 的直接子件,链接风格,muted 色)。
    Button {
        Layout.alignment: Qt.AlignHCenter
        variant: Button.Link
        size: Button.Sm
        text: "Learn More"
        trailingIconName: "arrow-up-right"
    }
}
