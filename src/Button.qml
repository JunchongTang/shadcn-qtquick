import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import LucideIcons

// shadcn Button(base-mira) —— 强类型枚举 variant/size,支持前后图标插槽。
// 尺寸严格对齐 style-mira.css 的 .cn-button-size-*(紧凑风格)。
// 基类别名导入(as C),使文件自身类型名 Button 可用于枚举访问。
C.Button {
    id: control

    enum Variant { Default, Secondary, Outline, Ghost, Destructive, Link }
    // 尺寸命名对齐 shadcn:Default/Sm/Lg/Xs + 四种正方形图标尺寸。
    enum Size { Default, Sm, Lg, Xs, Icon, IconSm, IconXs, IconLg }
    // 在 ButtonGroup 中的相邻位置 —— 决定圆角哪几个角被拉直。
    // 横向:First 留左、Last 留右;纵向(groupVertical):First 留上、Last 留下。
    enum GroupPosition { GroupNone, GroupFirst, GroupMiddle, GroupLast }

    property int variant: Button.Default
    property int size: Button.Default
    property string iconName: ""          // 前置图标(Lucide 名)
    property string trailingIconName: ""  // 后置图标(Lucide 名)
    property bool rounded: false          // rounded-full:胶囊全圆角
    property bool loading: false          // 显示 Spinner 并禁用交互(前置位)
    property int groupPosition: Button.GroupNone  // 由 ButtonGroup 自动设置
    property bool groupVertical: false             // 纵向分组(由 ButtonGroup 自动设置)

    // loading 时禁用交互(消费方显式设 enabled 可覆盖此绑定)。
    enabled: !loading

    readonly property bool _iconOnly: size === Button.Icon || size === Button.IconSm
                                   || size === Button.IconXs || size === Button.IconLg

    // 高度/正方形边长(mira: xs20 sm24 default28 lg32;icon 系列同高)。
    readonly property real _dim: {
        switch (size) {
        case Button.Xs: case Button.IconXs: return 20
        case Button.Sm: case Button.IconSm: return 24
        case Button.Lg: case Button.IconLg: return 32
        case Button.Icon: return 28
        default: return 28 // Default
        }
    }
    // 图标像素:xs10 sm12 default14 lg16(与文字并列时的 svg size-*)。
    readonly property int _iconSize: {
        switch (size) {
        case Button.Xs: case Button.IconXs: return 10
        case Button.Sm: case Button.IconSm: return 12
        case Button.Lg: case Button.IconLg: return 16
        case Button.Icon: return 14
        default: return 14 // Default
        }
    }
    readonly property int _textSize: size === Button.Xs ? 10 : Theme.textXs
    readonly property real _radius: (size === Button.Xs || size === Button.IconXs)
                                    ? Theme.radiusSm : Theme.radiusMd
    // 有效圆角:rounded 时用胶囊全圆角,否则按尺寸圆角。
    readonly property real _effRadius: rounded ? Theme.radiusFull : _radius
    // 水平内边距:lg 用 px-2.5(10),其余 px-2(8);带图标一侧减 2(pl-1.5/pr-1.5)。
    readonly property real _hpad: size === Button.Lg ? Theme.space2_5 : Theme.space2

    implicitHeight: _dim
    implicitWidth: _iconOnly ? _dim
                             : Math.max(contentItem.implicitWidth + leftPadding + rightPadding, _dim)

    padding: 0
    leftPadding: _iconOnly ? 0 : _hpad - ((iconName !== "" || loading) ? 2 : 0)
    rightPadding: _iconOnly ? 0 : _hpad - (trailingIconName !== "" ? 2 : 0)
    font.pixelSize: _textSize
    font.weight: Font.Medium
    hoverEnabled: true
    // 点击也可夺取焦点(对标 web:点按钮会使当前聚焦的输入框失焦)。
    // 焦点环用 visualFocus 门控 → 鼠标点击不显环,仅键盘 Tab 聚焦显环(= focus-visible)。
    focusPolicy: Qt.StrongFocus
    opacity: enabled ? 1.0 : 0.5

    readonly property color _fg: {
        switch (variant) {
        case Button.Default: return Theme.primaryForeground
        case Button.Secondary: return Theme.secondaryForeground
        case Button.Destructive: return Theme.destructive
        case Button.Link: return Theme.primary
        default: return Theme.foreground // Outline / Ghost
        }
    }

    contentItem: Item {
        implicitWidth: row.implicitWidth
        implicitHeight: row.implicitHeight
        // active:translate-y-px —— 按下时内容下沉 1px。
        transform: Translate { y: control.down ? 1 : 0 }

        RowLayout {
            id: row
            anchors.centerIn: parent
            spacing: Theme.space1 // gap-1

            Spinner {
                visible: control.loading
                size: control._iconSize
                color: control._fg
            }
            LucideIcon {
                visible: control.iconName !== "" && !control.loading
                name: control.iconName
                size: control._iconSize
                color: control._fg
            }
            Text {
                visible: !control._iconOnly && control.text !== ""
                text: control.text
                font.pixelSize: control.font.pixelSize
                font.weight: control.font.weight
                font.underline: control.variant === Button.Link && control.hovered
                color: control._fg
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
            LucideIcon {
                visible: control.trailingIconName !== ""
                name: control.trailingIconName
                size: control._iconSize
                color: control._fg
            }
        }
    }

    background: Rectangle {
        id: bg
        radius: control._effRadius
        // 分组时拉直相邻内侧角。横向:First 留左、Last 留右;纵向:First 留上、Last 留下;
        // Middle 全直;None 全圆。逐角推导(_r=有效圆角)。
        readonly property real _r: control._effRadius
        readonly property bool _n: control.groupPosition === Button.GroupNone
        readonly property bool _f: control.groupPosition === Button.GroupFirst
        readonly property bool _l: control.groupPosition === Button.GroupLast
        readonly property bool _v: control.groupVertical
        topLeftRadius:     (_n || _f) ? _r : 0
        bottomRightRadius: (_n || _l) ? _r : 0
        topRightRadius:    (_n || (!_v && _l) || (_v && _f)) ? _r : 0
        bottomLeftRadius:  (_n || (!_v && _f) || (_v && _l)) ? _r : 0
        border.width: control.variant === Button.Outline ? 1 : 0
        border.color: Theme.border
        transform: Translate { y: control.down ? 1 : 0 }
        color: {
            switch (control.variant) {
            case Button.Default:
                return control.hovered ? Theme.alpha(Theme.primary, 0.8) : Theme.primary
            case Button.Secondary:
                return control.hovered ? Qt.darker(Theme.secondary, 1.05) : Theme.secondary
            case Button.Destructive:
                return Theme.alpha(Theme.destructive, control.hovered ? 0.2 : 0.1)
            case Button.Outline:
                return control.hovered ? Theme.alpha(Theme.input, 0.5) : Theme.alpha(Theme.input, 0)
            case Button.Ghost:
                return control.hovered ? Theme.muted : Theme.alpha(Theme.muted, 0)
            default:
                return "transparent" // Link
            }
        }
        //Behavior on color { ColorAnimation { duration: Theme.durBase } }

        // 仅键盘 focus-visible 显环(鼠标点击夺焦不显环);环随背景逐角圆角
        // (分组内被拉直的一侧,环同为直角)。
        FocusRing {
            active: control.visualFocus
            targetRadius: control._effRadius
            targetTopLeft: bg.topLeftRadius
            targetTopRight: bg.topRightRadius
            targetBottomLeft: bg.bottomLeftRadius
            targetBottomRight: bg.bottomRightRadius
        }
    }
}
