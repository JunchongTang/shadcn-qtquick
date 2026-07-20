import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC
import QtQuick.Controls.Basic as C
import QtQuick.Effects
import LucideIcons

// shadcn Alert Dialog(base-mira)—— 打断式确认对话框。像素对齐 style-mira.css 的 .cn-alert-dialog-*。
// 与 Dialog 的差异:居中、无右上角关闭按钮、footer 为 Cancel(outline)+ Action、可选顶部 media 图标、尺寸 default/sm。
// 文件名 AlertDialog 与基类 Dialog 不同名,但仍别名导入(as C),根用 C.Dialog。
C.Dialog {
    id: control

    enum Size { Default, Sm }

    // title 继承自基类 Dialog,直接使用。以下为本组件新增。
    property string description: ""           // header 描述(muted,text-xs/relaxed)
    property string mediaIconName: ""          // 可选顶部 media 图标(Lucide 名)
    property bool mediaDestructive: false      // media 用 destructive 配色(bg-destructive/10 + text-destructive)
    property string cancelText: qsTr("Cancel")
    property string actionText: qsTr("Continue")
    property int actionVariant: Button.Default // Action 按钮变体(Button 枚举)
    property int size: AlertDialog.Default

    // 触发信号:Action 点击后先发 accepted 再 close。
    signal accepted()

    readonly property bool _sm: size === AlertDialog.Sm
    readonly property bool _hasMedia: mediaIconName !== ""
    // sm 尺寸居中;default 尺寸左对齐(对标 sm:group-data-[size=default] 的 place-items-start)。
    readonly property bool _centered: _sm

    modal: true
    anchors.centerIn: parent                   // 居中于父项
    padding: Theme.space4                      // content p-4
    // 关掉基类因 title 非空而自动生成的标题栏/按钮栏(会带直角默认底色、盖住圆角)。
    // header/footer 已全部收进 contentItem。
    header: null
    footer: null
    // content 网格宽度:default 用 max-w-sm(384),sm 用 max-w-64(256)。
    implicitWidth: _sm ? 256 : 384

    // 模态遮罩:black/80(对标 cn-alert-dialog-overlay bg-black/80)
    QQC.Overlay.modal: Rectangle { color: Theme.alpha("#000000", 0.8) }

    // 内容面:popover 底 + ring-1 ring-foreground/10 + rounded-xl + shadow。
    background: Rectangle {
        color: Theme.popover
        radius: Theme.radiusXl
        border.width: Theme.overlayRingWidth
        border.color: Theme.overlayRing
        layer.enabled: true
        layer.effect: MultiEffect {
            autoPaddingEnabled: true
            shadowEnabled: true
            shadowColor: Theme.shadowColor
            shadowBlur: Theme.shadowBlur
            shadowVerticalOffset: Theme.shadowOffset
        }
    }

    // 整个 header + footer 收进 contentItem,统一 p-4,块间 gap-3。
    contentItem: ColumnLayout {
        spacing: Theme.space3     // content gap-3

        // ==== header:default+media(左右并排,media row-span-2)====
        RowLayout {
            visible: !control._centered && control._hasMedia
            Layout.fillWidth: true
            spacing: Theme.space4      // gap-x-4

            Rectangle {                // media(size-8 rounded-md)
                Layout.alignment: Qt.AlignTop
                implicitWidth: 32
                implicitHeight: 32
                radius: Theme.radiusMd
                color: control.mediaDestructive ? Theme.alpha(Theme.destructive, 0.1) : Theme.muted
                LucideIcon {
                    anchors.centerIn: parent
                    name: control.mediaIconName
                    size: 16           // svg size-4
                    color: control.mediaDestructive ? Theme.destructive : Theme.foreground
                }
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.space1  // gap-1
                Text {
                    Layout.fillWidth: true
                    text: control.title
                    color: Theme.foreground
                    font.pixelSize: Theme.textSm   // text-sm = 14
                    font.weight: Font.Medium
                    wrapMode: Text.Wrap
                }
                Text {
                    visible: control.description !== ""
                    Layout.fillWidth: true
                    text: control.description
                    color: Theme.mutedForeground
                    font.pixelSize: Theme.textXs    // text-xs = 12
                    lineHeight: Theme.lineRelaxed
                    lineHeightMode: Text.ProportionalHeight
                    wrapMode: Text.Wrap
                }
            }
        }

        // ==== header:堆叠(sm 居中,或 default 无 media)====
        ColumnLayout {
            visible: control._centered || !control._hasMedia
            Layout.fillWidth: true
            spacing: Theme.space1      // gap-1

            Rectangle {                // media(仅居中态出现,mb-2)
                visible: control._hasMedia
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: Theme.space1   // + gap-1 = mb-2(8)
                implicitWidth: 32
                implicitHeight: 32
                radius: Theme.radiusMd
                color: control.mediaDestructive ? Theme.alpha(Theme.destructive, 0.1) : Theme.muted
                LucideIcon {
                    anchors.centerIn: parent
                    name: control.mediaIconName
                    size: 16
                    color: control.mediaDestructive ? Theme.destructive : Theme.foreground
                }
            }
            Text {
                Layout.fillWidth: true
                text: control.title
                color: Theme.foreground
                font.pixelSize: Theme.textSm
                font.weight: Font.Medium
                wrapMode: Text.Wrap
                horizontalAlignment: control._centered ? Text.AlignHCenter : Text.AlignLeft
            }
            Text {
                visible: control.description !== ""
                Layout.fillWidth: true
                text: control.description
                color: Theme.mutedForeground
                font.pixelSize: Theme.textXs
                lineHeight: Theme.lineRelaxed
                lineHeightMode: Text.ProportionalHeight
                wrapMode: Text.Wrap
                horizontalAlignment: control._centered ? Text.AlignHCenter : Text.AlignLeft
            }
        }

        // ==== footer:Cancel(outline)+ Action。default 右对齐;sm 两等分列 ====
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.space2            // gap-2
            Item { visible: !control._sm; Layout.fillWidth: true }
            Button {
                text: control.cancelText
                variant: Button.Outline
                Layout.fillWidth: control._sm
                onClicked: control.close()
            }
            Button {
                text: control.actionText
                variant: control.actionVariant
                Layout.fillWidth: control._sm
                onClicked: { control.accepted(); control.close() }
            }
        }
    }

    // 弹出动效:仅 zoom(scale 0.95→1),面板保持不透明,避免淡入时透出黑遮罩造成"开场黑闪";
    // 模态遮罩自身的淡入已提供出现感。对标 zoom-in-95。
    enter: Transition {
        NumberAnimation { property: "scale"; from: 0.95; to: 1; duration: Theme.durBase; easing.type: Easing.OutCubic }
    }
    exit: Transition {
        NumberAnimation { property: "scale"; from: 1; to: 0.95; duration: Theme.durFast; easing.type: Easing.InCubic }
    }
}
