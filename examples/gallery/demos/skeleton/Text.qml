import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    width: 300
    spacing: 8
    Skeleton { Layout.fillWidth: true; implicitHeight: 16 }
    Skeleton { Layout.fillWidth: true; implicitHeight: 16 }
    Skeleton { Layout.preferredWidth: 225; implicitHeight: 16 }
}
