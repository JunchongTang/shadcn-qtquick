import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import QtQuick.Effects
import LucideIcons

/*!
    \qmltype TabButton
    \inqmlmodule Shadcn
    \inherits TabButton
    \brief A single trigger inside a \l Tabs strip.

    TabButton ports shadcn base-mira's \c .cn-tabs-trigger. It reads its variant
    and orientation from the enclosing \l Tabs (a \c TabBar) via the
    \c TabBar attached property, so it renders the right decoration automatically:

    \list
        \li \c Default variant: the active trigger shows a \c background pill with
            \c rounded-md corners and, in dark mode, a 1px \c input border.
        \li \c Line variant: no pill; the active trigger gets a 2px foreground
            underline along the bottom (horizontal) or right (vertical) edge.
    \endlist

    The label uses the foreground color when active/hovered, and the muted
    foreground (dark) or foreground at 60% (light) otherwise. An optional leading
    \l iconName renders a 14px Lucide icon.

    \note The file is intentionally named \c TabButton and re-roots on the aliased
    base \c C.TabButton so the plain \c TabButton identifier stays free for enum
    resolution and to avoid an inheritance cycle.

    \sa Tabs
*/
C.TabButton {
    id: control

    /*! \qmlproperty string TabButton::iconName \brief Optional leading Lucide icon (kebab-case name). */
    property string iconName: ""

    // Variant/orientation are read from the enclosing Tabs (TabBar) so a bare
    // TabButton adapts to whichever strip it is placed in.
    readonly property var _bar: C.TabBar.tabBar
    readonly property bool _line: _bar ? _bar._line === true : false
    readonly property bool _vertical: _bar ? _bar.vertical === true : false

    // Label/icon color: foreground when active/hovered; otherwise muted-foreground
    // in dark mode and foreground/60 in light mode (matches text-foreground/60
    // dark:text-muted-foreground from the reference).
    readonly property color _fg: (control.checked || control.hovered || control.down)
                                 ? Theme.foreground
                                 : (Theme.dark ? Theme.mutedForeground
                                               : Theme.alpha(Theme.foreground, 0.6))

    // px-1.5 (6); a leading icon tightens the left side to pl-1 (4).
    leftPadding: iconName !== "" ? Theme.space1 : Theme.space1_5
    rightPadding: Theme.space1_5
    topPadding: _vertical ? 5 : 0   // vertical: py-[calc(--spacing(1.25))] = 5px
    bottomPadding: _vertical ? 5 : 0
    implicitHeight: _vertical ? (contentItem.implicitHeight + topPadding + bottomPadding)
                              : 26  // list h-8 (32) minus p-[3px] both sides = 26
    // Vertical: every trigger fills the list width so the active pill and muted
    // background stay aligned. Bind to ListView.view.width (not implicitWidth) to
    // break the binding loop against Tabs._maxChildWidth (fix #005 - do not regress).
    width: (control._vertical && ListView.view) ? ListView.view.width : implicitWidth
    font.pixelSize: Theme.textXs
    font.weight: Font.Medium
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus     // Tab-focusable; arrow-key switching handled by the base TabBar
    opacity: enabled ? 1.0 : 0.5    // disabled:opacity-50

    contentItem: Item {
        implicitWidth: row.implicitWidth
        implicitHeight: row.implicitHeight

        RowLayout {
            id: row
            spacing: Theme.space1_5   // gap-1.5
            anchors.verticalCenter: parent.verticalCenter
            // vertical: justify-start (left); horizontal: centered.
            anchors.left: control._vertical ? parent.left : undefined
            anchors.horizontalCenter: control._vertical ? undefined : parent.horizontalCenter

            LucideIcon {
                visible: control.iconName !== ""
                name: control.iconName
                size: 14              // size-3.5
                color: control._fg
                Behavior on color { ColorAnimation { duration: Theme.durFast } }
            }
            Text {
                text: control.text
                visible: control.text !== ""
                font: control.font
                color: control._fg
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                Behavior on color { ColorAnimation { duration: Theme.durFast } }
            }
        }
    }

    background: Item {
        // Default variant pill: on active, paints a background fill (shadow-sm in
        // the reference) plus a dark-mode input border.
        Rectangle {
            id: pill
            anchors.fill: parent
            visible: !control._line
            radius: Theme.radiusMd          // rounded-md
            color: control.checked ? Theme.background : Theme.alpha(Theme.background, 0)
            border.width: control.checked && Theme.dark ? 1 : 0
            border.color: Theme.input
        }

        // Line variant underline: fades in when active. Horizontal fills the
        // bottom edge; vertical fills the right edge. Always 2px foreground.
        Rectangle {
            id: underline
            visible: control._line
            color: Theme.foreground
            opacity: control.checked ? 1 : 0
            width: control._vertical ? 2 : undefined
            height: control._vertical ? undefined : 2
            anchors.left: control._vertical ? undefined : parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: control._vertical ? parent.top : undefined
            Behavior on opacity { NumberAnimation { duration: Theme.durFast } }
        }

        FocusRing {
            active: control.visualFocus
            targetRadius: control._line ? Theme.radiusSm : pill.radius
        }
    }
}
