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
            text: "Default"; variant: Button.Outline
            onClicked: area.show("Event has been created")
        }
        Button {
            text: "Success"; variant: Button.Outline
            onClicked: area.success("Event has been created")
        }
        Button {
            text: "Info"; variant: Button.Outline
            onClicked: area.info("Be at the area 10 minutes before the event time")
        }
        Button {
            text: "Warning"; variant: Button.Outline
            onClicked: area.warning("Event start time cannot be earlier than 8am")
        }
        Button {
            text: "Error"; variant: Button.Outline
            onClicked: area.error("Event has not been created")
        }
    }

    ToastArea { id: area; anchors.fill: parent }
}
