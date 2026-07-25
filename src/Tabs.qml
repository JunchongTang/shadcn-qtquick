import QtQuick
import QtQuick.Controls.Basic as C

/*!
    \qmltype Tabs
    \inqmlmodule Shadcn
    \inherits TabBar
    \brief A segmented tab strip (the shadcn "tabs list").

    Tabs ports shadcn base-mira's \c .cn-tabs-list. It is the container for a set
    of \l TabButton triggers and mirrors the \c TabsList element only: content
    panels are left to the caller, who typically binds a \c StackLayout's
    \c currentIndex to \l {TabBar::}{currentIndex}.

    The \c Default variant paints a \c muted rounded background with the active
    trigger rendered as a filled "pill". The \c Line variant drops the background
    (\c bg-transparent), squares the corners, spaces triggers with \c gap-1 and
    marks the active trigger with a foreground underline instead of a pill.

    Set \l vertical to stack triggers in a column; \l orientation reports the
    same state as an enumeration for readability.

    \qml
    Tabs {
        TabButton { text: "Account" }
        TabButton { text: "Password" }
    }
    \endqml

    \sa TabButton
*/
C.TabBar {
    id: control

    /*!
        \qmlproperty enumeration Tabs::variant
        Visual style of the tab strip:
        \value Tabs.Default Muted rounded background; active trigger is a filled pill.
        \value Tabs.Line No background, square corners, gap-1 spacing; active trigger is underlined.
    */
    enum Variant { Default, Line }

    /*!
        \qmlproperty enumeration Tabs::orientation
        Layout direction of the triggers. This is a read-only reflection of
        \l vertical, exposed to match shadcn's \c orientation prop.
        \value Tabs.Horizontal Triggers laid out in a row (default).
        \value Tabs.Vertical Triggers stacked in a column.

        \note \c Horizontal/\c Vertical do not collide with the inherited
        \c Item.TransformOrigin names (Top/Left/Center/Right/Bottom), nor do the
        flattened \l Variant names, so both enums coexist safely in the type scope.
    */
    enum Orientation { Horizontal, Vertical }

    /*! \qmlproperty int Tabs::variant \brief The visual style; see \l Variant. Defaults to \c Tabs.Default. */
    property int variant: Tabs.Default
    /*! \qmlproperty bool Tabs::vertical \brief Stacks triggers in a column when \c true. Defaults to \c false. */
    property bool vertical: false
    /*! \qmlproperty int Tabs::orientation \brief Read-only enum reflection of \l vertical; see \l Orientation. */
    readonly property int orientation: vertical ? Tabs.Vertical : Tabs.Horizontal

    /*! \internal Convenience: true for the Line variant. */
    readonly property bool _line: variant === Tabs.Line

    // Widest child implicit width (vertical strips size to the widest trigger).
    // Reads implicitWidth (never width) so it cannot feed back into the
    // trigger's width binding; see the #005 note in TabButton.qml.
    readonly property real _maxChildWidth: {
        let w = 0
        for (let i = 0; i < contentChildren.length; i++) {
            const it = contentChildren[i]
            if (it && it.implicitWidth > w) w = it.implicitWidth
        }
        return w
    }
    // Sum of child implicit widths plus inter-item spacing (horizontal strips
    // fit their content, mirroring the w-fit list; callers may override width).
    readonly property real _sumChildWidth: {
        let s = 0, n = 0
        for (let i = 0; i < contentChildren.length; i++) {
            const it = contentChildren[i]
            if (it) { s += it.implicitWidth; n++ }
        }
        return s + Math.max(0, n - 1) * spacing
    }

    padding: Theme.space1 - 1           // p-[3px]
    spacing: _line ? Theme.space1 : 0   // line: gap-1; default: pills sit flush

    implicitWidth: (vertical ? _maxChildWidth : _sumChildWidth) + leftPadding + rightPadding
    implicitHeight: vertical ? list.contentHeight + topPadding + bottomPadding : 32  // h-8

    contentItem: ListView {
        id: list
        model: control.contentModel
        currentIndex: control.currentIndex
        spacing: control.spacing
        orientation: control.vertical ? ListView.Vertical : ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.AutoFlickIfNeeded
        snapMode: ListView.SnapToItem
        highlightMoveDuration: 0
        highlightRangeMode: ListView.ApplyRange
        preferredHighlightBegin: 40
        preferredHighlightEnd: (control.vertical ? height : width) - 40
    }

    background: Rectangle {
        radius: control._line ? 0 : Theme.radiusLg   // line: rounded-none
        color: control._line ? "transparent" : Theme.muted
    }
}
