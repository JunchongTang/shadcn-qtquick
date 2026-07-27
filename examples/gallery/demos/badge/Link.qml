import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8

    // Use the Link variant to present the Badge as a link, with a trailing arrow-up-right icon.
    Badge {
        variant: Badge.Link
        text: qsTr("Open Link")
        trailingIconName: "arrow-up-right"
    }
}
