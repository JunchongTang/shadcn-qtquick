import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import LucideIcons

// shadcn Toggle(base-mira) —— 两态按钮(on/off)。checkable 复用 C.Button 的 checked。
// 尺寸/变体严格对齐 style-mira.css 的 .cn-toggle-*(紧凑风格)。
// variant:Default(透明底)/Outline(input 描边);size:Sm/Default/Lg。
// 选中态(data-[state=on])与 hover 均为 bg-muted;文字/图标恒用 foreground。
C.Button {
    id: control

    enum Variant { Default, Outline }
    enum Size { Sm, Default, Lg }

    property int variant: Toggle.Default
    property int size: Toggle.Default
    property string iconName: ""   // 前置图标(Lucide kebab-case 名)

    checkable: true

    // 高度/最小方形边长(mira: sm24 default28 lg32)。
    readonly property real _dim: size === Toggle.Sm ? 24 : size === Toggle.Lg ? 32 : 28
    // 图标像素:sm 用 size-3(12),其余 size-4(16)。
    readonly property int _iconSize: size === Toggle.Sm ? 12 : 16
    // 文字:sm text-[0.625rem]=10,其余 text-xs=12。
    readonly property int _textSize: size === Toggle.Sm ? 10 : Theme.textXs
    // rounded-md;sm 为 rounded-[min(radius-md,8px)] —— 二者皆等于 radiusMd(8)。
    readonly property real _radius: Theme.radiusMd
    // 水平内边距:lg px-2.5(10),其余 px-2(8);带图标一侧减 2(pl-1.5/pr-1.5)。
    readonly property real _hpad: size === Toggle.Lg ? Theme.space2_5 : Theme.space2

    readonly property bool _hasText: text !== ""

    implicitHeight: _dim
    implicitWidth: Math.max(contentItem.implicitWidth + leftPadding + rightPadding, _dim)

    padding: 0
    leftPadding: _hpad - (iconName !== "" ? 2 : 0)
    rightPadding: _hpad
    font.pixelSize: _textSize
    font.weight: Font.Medium
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus     // 键盘可 Tab 聚焦(Space/Enter 切换由 AbstractButton 自带)
    opacity: enabled ? 1.0 : 0.5

    contentItem: Item {
        implicitWidth: row.implicitWidth
        implicitHeight: row.implicitHeight

        RowLayout {
            id: row
            anchors.centerIn: parent
            spacing: Theme.space1 // gap-1

            LucideIcon {
                visible: control.iconName !== ""
                name: control.iconName
                size: control._iconSize
                color: Theme.foreground
            }
            Text {
                visible: control._hasText
                text: control.text
                font.pixelSize: control.font.pixelSize
                font.weight: control.font.weight
                color: Theme.foreground
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
        }
    }

    background: Rectangle {
        radius: control._radius
        border.width: control.variant === Toggle.Outline ? 1 : 0
        border.color: Theme.input
        // 选中或 hover → bg-muted;否则透明。
        color: (control.checked || control.hovered) ? Theme.muted : Theme.alpha(Theme.muted, 0)
        Behavior on color { ColorAnimation { duration: Theme.durBase } }

        FocusRing { active: control.visualFocus; targetRadius: control._radius }
    }
}
