import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 spinner-empty:icon 圆底内放 Spinner(处理中状态)。
Empty {
    EmptyHeader {
        EmptyMedia {
            variant: EmptyMedia.Icon
            Spinner { size: 16 }    // 圆底内 svg size-4
        }
        EmptyTitle { text: qsTr("Processing your request") }
        EmptyDescription {
            text: qsTr("Please wait while we process your request. Do not refresh the page.")
        }
    }

    EmptyContent {
        Button {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Cancel")
            variant: Button.Outline
            size: Button.Sm
        }
    }
}
