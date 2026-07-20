import QtQuick
import QtQuick.Layouts
import Shadcn

// 气泡配 Popover:失败气泡的表情行放信息按钮,点击展开完整错误详情。
// 对标官方 bubble-popover。
ColumnLayout {
    width: 360
    spacing: 16

    Bubble {
        align: Bubble.End
        BubbleContent { text: "Run the build script." }
    }

    Bubble {
        variant: Bubble.Destructive
        BubbleContent { text: "Failed to run the command." }
        BubbleReactions {
            padded: false
            Button {
                id: infoBtn
                variant: Button.Ghost
                size: Button.IconXs
                iconName: "info"
                onClicked: errPop.open()

                Popover {
                    id: errPop
                    width: 288
                    align: Popover.Align.End

                    ColumnLayout {
                        width: errPop.availableWidth
                        spacing: 6
                        Text {
                            Layout.fillWidth: true
                            text: "Command failed with exit code 1"
                            color: Theme.foreground
                            font.pixelSize: Theme.textSm
                            font.weight: Font.Medium
                            wrapMode: Text.Wrap
                        }
                        Text {
                            Layout.fillWidth: true
                            text: "ENOENT: no such file or directory, open pnpm-lock.yaml"
                            color: Theme.mutedForeground
                            font.pixelSize: Theme.textSm
                            wrapMode: Text.Wrap
                        }
                    }
                }
            }
        }
    }
}
