import QtQuick
import QtQuick.Layouts
import Shadcn

// Card Spacing —— 对标官方 card-spacing:用 ToggleGroup 切换 --card-spacing
// (16 / 20 / 24 / 32px),实时改变卡片各区块的内边距与区块间距。
ColumnLayout {
    id: root
    width: 360
    spacing: 16

    property real selectedSpacing: 16

    ToggleGroup {
        Layout.alignment: Qt.AlignHCenter
        variant: ToggleGroup.Outline
        size: ToggleGroup.Sm
        ToggleGroupItem { text: "16px"; checked: true; onCheckedChanged: if (checked) root.selectedSpacing = 16 }
        ToggleGroupItem { text: "20px"; onCheckedChanged: if (checked) root.selectedSpacing = 20 }
        ToggleGroupItem { text: "24px"; onCheckedChanged: if (checked) root.selectedSpacing = 24 }
        ToggleGroupItem { text: "32px"; onCheckedChanged: if (checked) root.selectedSpacing = 32 }
    }

    Card {
        Layout.fillWidth: true
        cardSpacing: root.selectedSpacing

        CardHeader {
            // 标题/描述在左,操作(Sign Up 链接)在右上(对标 CardAction)。
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.space2
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.space1
                    CardTitle { text: "Login to your account" }
                    CardDescription { text: "Enter your email below to login to your account" }
                }
                Button { text: "Sign Up"; variant: Button.Link; Layout.alignment: Qt.AlignTop }
            }
        }

        CardContent {
            spacing: 24 // 表单字段间 gap-6
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.space2
                Label { text: "Email" }
                Input { Layout.fillWidth: true; placeholderText: "m@example.com" }
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.space2
                RowLayout {
                    Layout.fillWidth: true
                    Label { text: "Password" }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: "Forgot your password?"
                        color: Theme.foreground
                        font.pixelSize: Theme.textSm
                    }
                }
                Input { Layout.fillWidth: true; echoMode: TextInput.Password }
            }
        }

        CardFooter {
            // flex-col gap-2:两个全宽按钮竖排。
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.space2
                Button { Layout.fillWidth: true; text: "Login" }
                Button { Layout.fillWidth: true; text: "Login with Google"; variant: Button.Outline }
            }
        }
    }
}
