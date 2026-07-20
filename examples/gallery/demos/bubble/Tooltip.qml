import QtQuick
import QtQuick.Layouts
import Shadcn

// 气泡配 Tooltip:在表情行放一个图标按钮,悬停显示元数据(已读时间)。
// 对标官方 bubble-tooltip。
ColumnLayout {
    width: 360
    spacing: 16

    Bubble {
        variant: Bubble.Secondary
        BubbleContent { text: "Did you remove the stale route?" }
    }

    Bubble {
        align: Bubble.End
        BubbleContent { text: "Yes, removed it from the registry." }
        BubbleReactions {
            padded: false
            Button {
                id: readBtn
                variant: Button.Ghost
                size: Button.IconXs
                iconName: "check"
                Tooltip {
                    text: "Read on Jan 5, 2026 at 4:32 PM"
                    visible: readBtn.hovered
                }
            }
        }
    }
}
