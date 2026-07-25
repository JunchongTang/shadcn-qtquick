import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import LucideIcons

/*!
    \qmltype Toast
    \inqmlmodule Shadcn
    \inherits Rectangle
    \brief A single Sonner-style notification card.

    Toast is the visual for one notification, styled after shadcn's base-mira
    Sonner (\c registry/bases/base/ui/sonner.tsx). It maps Sonner's
    \c --normal-* variables and \c .cn-toast rule: \c popover background,
    \c popover-foreground text, \c rounded-md corners, and the shared overlay
    depth used by popover/dialog/menu (a 1px \c ring-foreground/10 border plus a
    \c shadow-md drop shadow via \l Theme.overlayRing and \l Theme.shadowColor).

    A leading Lucide icon is derived from \l type using Sonner's icon map
    (\c circle-check / \c info / \c triangle-alert / \c octagon-x /
    \c loader-circle). base-mira does not enable \c richColors, so the icon
    follows the text color rather than a per-type accent. An optional action
    button appears on the right when \l actionText is set.

    Toasts are normally created and stacked by \l ToastArea rather than
    instantiated directly.

    \qml
    Toast { type: Toast.Success; title: "Saved"; description: "Your changes are live." }
    \endqml

    \sa ToastArea
*/
Rectangle {
    id: control

    /*!
        \qmlproperty enumeration Toast::type
        The notification kind, which selects the leading icon.
        \value Toast.Default No icon.
        \value Toast.Success \c circle-check icon.
        \value Toast.Info    \c info icon.
        \value Toast.Warning \c triangle-alert icon.
        \value Toast.Error   \c octagon-x icon.
        \value Toast.Loading \c loader-circle icon, spinning continuously.
    */
    enum Type { Default, Success, Info, Warning, Error, Loading }

    /*! \qmlproperty int Toast::type \brief The notification kind; see \l Type. Defaults to \c Toast.Default. */
    property int type: Toast.Default
    /*! \qmlproperty string Toast::title \brief The primary message line. */
    property string title: ""
    /*! \qmlproperty string Toast::description \brief Optional secondary line in muted text. */
    property string description: ""
    /*! \qmlproperty string Toast::actionText \brief When non-empty, shows a trailing action button with this label. */
    property string actionText: ""

    /*! \qmlsignal Toast::actionTriggered() \brief Emitted when the action button is clicked. */
    signal actionTriggered()

    // type -> Lucide icon name (Default has no icon).
    readonly property string _iconName: {
        switch (type) {
        case Toast.Success: return "circle-check"
        case Toast.Info: return "info"
        case Toast.Warning: return "triangle-alert"
        case Toast.Error: return "octagon-x"
        case Toast.Loading: return "loader-circle"
        default: return ""
        }
    }
    readonly property bool _hasIcon: _iconName !== ""

    // Sonner's default width is 356; fixed width, content wraps as needed.
    implicitWidth: 356
    implicitHeight: Math.max(row.implicitHeight + Theme.space4 * 2, 44)
    radius: Theme.radiusMd                // .cn-toast: rounded-md
    color: Theme.popover                  // --normal-bg: var(--popover)
    border.width: Theme.overlayRingWidth  // ring-1 ring-foreground/10 (shared overlay border)
    border.color: Theme.overlayRing

    // shadow-md (shared mira overlay depth).
    layer.enabled: true
    layer.effect: MultiEffect {
        autoPaddingEnabled: true
        shadowEnabled: true
        shadowColor: Theme.shadowColor
        shadowBlur: Theme.shadowBlur
        shadowVerticalOffset: Theme.shadowOffset
    }

    RowLayout {
        id: row
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: Theme.space4   // p-4
        anchors.rightMargin: Theme.space4
        spacing: Theme.space3              // gap-3 (icon to text)

        LucideIcon {
            visible: control._hasIcon
            name: control._iconName
            size: 16                       // size-4
            color: Theme.popoverForeground
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 1
            // Spin the loading icon.
            RotationAnimation on rotation {
                running: control.type === Toast.Loading && control._hasIcon
                from: 0; to: 360
                duration: 900
                loops: Animation.Infinite
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.space1          // gap-1 (title / description)
            Text {
                visible: control.title !== ""
                Layout.fillWidth: true
                text: control.title
                color: Theme.popoverForeground
                font.pixelSize: Theme.textSm
                font.weight: Font.Medium
                wrapMode: Text.Wrap
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
            }
        }

        // Trailing action button (Sonner action).
        Button {
            visible: control.actionText !== ""
            text: control.actionText
            size: Button.Xs
            Layout.alignment: Qt.AlignVCenter
            onClicked: control.actionTriggered()
        }
    }
}
