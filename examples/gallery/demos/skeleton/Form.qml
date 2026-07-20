import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    width: 300
    spacing: 24

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 10
        Skeleton { implicitWidth: 80; implicitHeight: 16 }
        Skeleton { Layout.fillWidth: true; implicitHeight: 32 }
    }
    ColumnLayout {
        Layout.fillWidth: true
        spacing: 10
        Skeleton { implicitWidth: 96; implicitHeight: 16 }
        Skeleton { Layout.fillWidth: true; implicitHeight: 32 }
    }
    Skeleton { implicitWidth: 96; implicitHeight: 32 }
}
