import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 empty-outline:虚线边框空状态(border border-dashed)。
Empty {
    outline: true

    EmptyHeader {
        EmptyMedia {
            variant: EmptyMedia.Icon
            iconName: "cloud"
        }
        EmptyTitle { text: qsTr("Cloud Storage Empty") }
        EmptyDescription {
            text: qsTr("Upload files to your cloud storage to access them anywhere.")
        }
    }

    EmptyContent {
        Button {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Upload Files")
            variant: Button.Outline
            size: Button.Sm
        }
    }
}
