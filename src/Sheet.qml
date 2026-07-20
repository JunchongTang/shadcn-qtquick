import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC
import QtQuick.Controls.Basic as C
import QtQuick.Effects

// shadcn Sheet(base-mira)—— 从屏幕边缘滑入、贴边铺满的面板,补充主内容。
// 像素对齐 style-mira.css 的 .cn-sheet-*(overlay/content/close/header/footer/title/description)。
// 基于 C.Drawer:天然处理「贴某条窗口边 + 滑入/滑出 + 模态遮罩」,无需手动定位。
//   · side 枚举 Top/Right/Bottom/Left(默认 Right),映射 Drawer.edge。
//   · 左右:占窗宽 3/4 但不超 max-w-sm(384)、满高、内侧边框;上下:满宽、内容高(h-auto)、内侧边框。
// 结构:header(title/description)+ 默认内容槽(body)+ footer(mt-auto),右上角关闭按钮。
C.Drawer {
    id: control

    enum Side { Top, Right, Bottom, Left }

    // ---- 对外 API ----
    property int side: Sheet.Right          // 贴哪条边、从哪滑入
    property string title: ""               // header 标题(text-sm medium)
    property string description: ""         // header 描述(muted,text-xs/relaxed)
    property bool showCloseButton: true     // 右上角关闭按钮(对标 XIcon)
    // 默认内容进 body;footer 单独赋值(对标 SheetFooter,mt-auto 贴底)。
    default property alias content: bodyLayout.data
    property Item footer: null

    // ---- 内部推导 ----
    readonly property bool _horizontal: side === Sheet.Left || side === Sheet.Right
    // 尺寸须按「窗口 overlay」而非 parent(Drawer 的 parent 是触发器,不是窗口)。
    readonly property var _ov: QQC.Overlay.overlay
    readonly property real _winW: _ov ? _ov.width : 400
    readonly property real _winH: _ov ? _ov.height : 600

    edge: side === Sheet.Top ? Qt.TopEdge
        : side === Sheet.Bottom ? Qt.BottomEdge
        : side === Sheet.Left ? Qt.LeftEdge
        : Qt.RightEdge

    // 尺寸:左右 = min(3/4 窗宽, 384) × 满高;上下 = 满宽 × 内容高(封顶窗高)。
    width: _horizontal ? Math.min(_winW * 0.75, 384) : _winW
    height: _horizontal ? _winH : Math.min(sheetCol.implicitHeight, _winH)

    modal: true
    padding: 0
    dragMargin: 0                           // 仅由触发器打开,不做边缘拖拽
    closePolicy: C.Popup.CloseOnEscape | C.Popup.CloseOnPressOutside

    onFooterChanged: if (footer) footer.parent = footerLayout

    // 模态遮罩:black/80(对标 .cn-sheet-overlay bg-black/80)。backdrop-blur 无对应令牌,略。
    QQC.Overlay.modal: Rectangle { color: Theme.alpha("#000000", 0.8) }

    // 面板:popover 底 + 贴边(无圆角)+ 内侧 1px 边框(border token)+ 投影(shadow-lg 近似)。
    background: Rectangle {
        color: Theme.popover
        radius: 0
        layer.enabled: true
        layer.effect: MultiEffect {
            autoPaddingEnabled: true
            shadowEnabled: true
            shadowColor: Theme.shadowColor
            shadowBlur: Theme.shadowBlur
            shadowVerticalOffset: Theme.shadowOffset
        }

        // 内侧边框:right→左边、left→右边、top→下边、bottom→上边。
        Rectangle {
            color: Theme.border
            width: control._horizontal ? 1 : parent.width
            height: control._horizontal ? parent.height : 1
            x: control.side === Sheet.Left ? parent.width - 1 : 0
            y: control.side === Sheet.Top ? parent.height - 1 : 0
        }
    }

    // 内容:header + body(填充,把 footer 顶到底)+ footer,右上角关闭按钮叠加。
    contentItem: Item {
        implicitHeight: sheetCol.implicitHeight

        ColumnLayout {
            id: sheetCol
            anchors.fill: parent
            spacing: 0

            // ==== header:gap-1.5 p-6 ====
            ColumnLayout {
                visible: control.title !== "" || control.description !== ""
                Layout.fillWidth: true
                Layout.margins: Theme.space6      // p-6
                spacing: Theme.space1_5           // gap-1.5
                Text {
                    visible: control.title !== ""
                    Layout.fillWidth: true
                    text: control.title
                    color: Theme.foreground
                    font.pixelSize: Theme.textSm       // text-sm
                    font.weight: Font.Medium
                    wrapMode: Text.Wrap
                }
                Text {
                    visible: control.description !== ""
                    Layout.fillWidth: true
                    text: control.description
                    color: Theme.mutedForeground
                    font.pixelSize: Theme.textXs       // text-xs/relaxed
                    lineHeight: Theme.lineRelaxed
                    lineHeightMode: Text.ProportionalHeight
                    wrapMode: Text.Wrap
                }
            }

            // ==== body:默认内容槽。填充剩余空间,使 footer 贴底(mt-auto)。====
            ColumnLayout {
                id: bodyLayout
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: Theme.space4        // 对标示例 body px-4
                Layout.rightMargin: Theme.space4
                spacing: Theme.space6                  // 示例 body gap-6
            }

            // ==== footer:gap-2 p-6,mt-auto(靠 body 的 fillHeight 顶到底)====
            ColumnLayout {
                id: footerLayout
                visible: control.footer !== null
                Layout.fillWidth: true
                Layout.margins: Theme.space6           // p-6
                spacing: Theme.space2                  // gap-2
            }
        }

        // ==== 右上角关闭按钮:absolute top-4 right-4 ====
        IconButton {
            visible: control.showCloseButton
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: Theme.space4
            anchors.rightMargin: Theme.space4
            iconName: "x"
            variant: IconButton.Ghost
            size: IconButton.Small
            onClicked: control.close()
        }
    }

    // 滑入/滑出:position 位移滑动 + 透明淡入(对标 transition duration-200 ease-in-out)。
    // Theme 无 200ms 令牌,取 durBase(150ms)近似。
    enter: Transition {
        NumberAnimation { property: "position"; from: 0; to: 1; duration: Theme.durBase; easing.type: Easing.InOutQuad }
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.durBase }
    }
    exit: Transition {
        NumberAnimation { property: "position"; from: 1; to: 0; duration: Theme.durBase; easing.type: Easing.InOutQuad }
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Theme.durBase }
    }
}
