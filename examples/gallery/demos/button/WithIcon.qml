import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8
    Button { iconName: "mail"; text: qsTr("Login with Email") }
    Button { text: qsTr("Continue"); trailingIconName: "arrow-right"; variant: Button.Secondary }
    Button { iconName: "download"; text: qsTr("Download"); variant: Button.Outline }
}
