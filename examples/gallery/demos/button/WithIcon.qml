import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8
    Button { iconName: "mail"; text: "Login with Email" }
    Button { text: "Continue"; trailingIconName: "arrow-right"; variant: Button.Secondary }
    Button { iconName: "download"; text: "Download"; variant: Button.Outline }
}
