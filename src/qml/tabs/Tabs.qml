import QtQuick
import QtQuick.Controls.Basic as C

/*!
    \qmltype Tabs
    \inqmlmodule Shadcn
    \inherits TabBar
    \brief A segmented tab strip (the shadcn "tabs list").
    \image tabs.png


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

    \section2 Trigger width

    Triggers follow shadcn's \c flex-1 sizing, driven by the width the strip is
    given (no dedicated property, mirroring the reference where the choice is the
    consumer's \c {w-fit} vs \c {w-full}):

    \list
        \li At its natural (content-fit) width — the default \l implicitWidth,
            i.e. the sum of the trigger widths — each trigger keeps its own
            content width.
        \li Stretched wider than that (e.g. \c {Layout.fillWidth: true}, an
            explicit \c width, or filling anchors), the triggers share the width
            equally: every trigger becomes the same width and together they fill
            the strip, regardless of label length.
    \endlist

    Vertical triggers always fill the strip width. So a full-width sidebar
    navigation is just \c {Tabs { Layout.fillWidth: true; ... }}.

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

    // Visual style of the tab strip (documented on the variant property).
    enum Variant { Default, Line }

    // Layout direction of the triggers (documented on the orientation property).
    // Horizontal/Vertical do not collide with the inherited Item.TransformOrigin
    // names, nor do the flattened Variant names, so both enums coexist safely.
    enum Orientation { Horizontal, Vertical }

    /*!
        \qmlproperty enumeration Tabs::variant
        The visual style. Defaults to \c Tabs.Default.

        \value Tabs.Default Muted rounded background; active trigger is a filled pill.
        \value Tabs.Line No background, square corners, gap-1 spacing; active trigger is underlined.
    */
    property int variant: Tabs.Default
    /*!
        \qmlproperty bool Tabs::vertical
        Stacks triggers in a column when \c true. Defaults to \c false.
    */
    property bool vertical: false
    /*!
        \qmlproperty enumeration Tabs::orientation
        Read-only enum reflection of \l vertical, exposed to match shadcn's
        \c orientation prop.

        \value Tabs.Horizontal Triggers laid out in a row (default).
        \value Tabs.Vertical Triggers stacked in a column.
    */
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
