import QtQuick
import QtQuick.Layouts
import Shadcn

// 各类型 toast:default / success / info / warning / error(对标 sonner-types)。
// base-mira 未启用 richColors,类型仅决定图标(circle-check/info/triangle-alert/octagon-x)。
Item {
    implicitWidth: 480
    implicitHeight: 220

    Flow {
        anchors.centerIn: parent
        width: Math.min(parent.width - 32, 440)
        spacing: 8

        Button {
            text: qsTr("Default"); variant: Button.Outline
            onClicked: area.show(qsTr("Event has been created"))
        }
        Button {
            text: qsTr("Success"); variant: Button.Outline
            onClicked: area.success(qsTr("Event has been created"))
        }
        Button {
            text: qsTr("Info"); variant: Button.Outline
            onClicked: area.info(qsTr("Be at the area 10 minutes before the event time"))
        }
        Button {
            text: qsTr("Warning"); variant: Button.Outline
            onClicked: area.warning(qsTr("Event start time cannot be earlier than 8am"))
        }
        Button {
            text: qsTr("Error"); variant: Button.Outline
            onClicked: area.error(qsTr("Event has not been created"))
        }
    }

    ToastArea { id: area; anchors.fill: parent }
}
