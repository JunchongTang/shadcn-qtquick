import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 16
    Skeleton { implicitWidth: 40; implicitHeight: 40; radius: 20 }
    ColumnLayout {
        spacing: 8
        Skeleton { implicitWidth: 150; implicitHeight: 16 }
        Skeleton { implicitWidth: 100; implicitHeight: 16 }
    }
}
