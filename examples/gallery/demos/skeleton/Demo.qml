import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 16
    Skeleton { implicitWidth: 48; implicitHeight: 48; radius: 24 }
    ColumnLayout {
        spacing: 8
        Skeleton { implicitWidth: 250; implicitHeight: 16 }
        Skeleton { implicitWidth: 200; implicitHeight: 16 }
    }
}
