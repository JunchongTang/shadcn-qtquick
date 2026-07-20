import QtQuick
import QtQuick.Layouts
import Shadcn

Card {
    width: 300
    CardHeader {
        Skeleton { Layout.preferredWidth: 180; implicitHeight: 16 }
        Skeleton { Layout.preferredWidth: 130; implicitHeight: 16 }
    }
    CardContent {
        Skeleton { Layout.fillWidth: true; implicitHeight: (300 - 32) * 9 / 16 } // aspect-video
    }
}
