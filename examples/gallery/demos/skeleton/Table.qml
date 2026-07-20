import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    width: 360
    spacing: 8

    Repeater {
        model: 5
        delegate: RowLayout {
            Layout.fillWidth: true
            spacing: 16
            Skeleton { Layout.fillWidth: true; implicitHeight: 16 }
            Skeleton { implicitWidth: 96; implicitHeight: 16 }
            Skeleton { implicitWidth: 80; implicitHeight: 16 }
        }
    }
}
