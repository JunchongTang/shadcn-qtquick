import QtQuick
import QtQuick.Controls.Basic as C
import QtQml.Models

/*!
    \qmltype Carousel
    \inqmlmodule Shadcn
    \inherits Item
    \brief A horizontally or vertically scrollable set of snapping slides.
    \image carousel.png


    Port of shadcn/ui's Carousel (base-mira style). The web component wraps
    the \c embla-carousel engine; this QML port approximates it with a
    snapping \c ListView plus two outline, round chevron navigation buttons
    placed just outside the content on the leading/trailing edge.

    Slides are supplied by the caller as \l CarouselItem children (the
    default property). \l orientation selects the scroll axis. Navigation is
    driven by \l scrollPrev() / \l scrollNext(), the Left/Right arrow keys, or
    dragging; the current slide snaps to the start of the viewport
    (\c {align: "start"}).

    Simplifications relative to embla: there is no loop mode or plugin system,
    and \l canScrollNext is approximated as "not on the last slide" rather than
    "no further content to reveal", so it is exact only for full-width
    (\c {basis: 1.0}) slides.

    \qml
    Carousel {
        width: 300; height: 200
        Repeater {
            model: 5
            CarouselItem {
                Card { anchors.fill: parent
                    Text { anchors.centerIn: parent; text: index + 1 } }
            }
        }
    }
    \endqml
*/
Item {
    id: control

    // Scroll axis of the carousel (documented on the orientation property).
    // Members Horizontal/Vertical do not collide with the inherited
    // Item.TransformOrigin members (Top/Left/Center/Right/Bottom), so QML's
    // flattening of enum values into the type scope is safe here (see #029).
    enum Orientation { Horizontal, Vertical }

    /*!
        \qmlproperty enumeration Carousel::orientation
        Scroll axis. Defaults to \c Carousel.Horizontal.

        \value Carousel.Horizontal Slides flow left-to-right; nav buttons sit
               left and right of the content. This is the default.
        \value Carousel.Vertical Slides flow top-to-bottom; nav buttons sit
               above and below the content.
    */
    property int orientation: Carousel.Horizontal

    /*!
        \qmlproperty real Carousel::spacing
        Gap between adjacent slides, in pixels. Mirrors the web
        \c {pl-4 / pt-4} slide padding. Defaults to \c 16.
    */
    property real spacing: 16

    /*!
        \qmlproperty int Carousel::currentIndex
        Index of the slide currently snapped to the start of the viewport.
        Read/write; changing it animates the carousel to that slide.
    */
    property alias currentIndex: view.currentIndex

    /*!
        \qmlproperty int Carousel::count
        Number of slides. Read-only.
    */
    property alias count: view.count

    /*!
        \qmlproperty list<QtObject> Carousel::content
        Default property. The \l CarouselItem slides, used directly as the
        internal ListView's delegate instances.
    */
    default property alias content: itemsModel.children

    readonly property bool _horizontal: orientation === Carousel.Horizontal

    /*!
        \qmlproperty bool Carousel::canScrollPrev
        Whether \l scrollPrev() can advance (not on the first slide). Read-only.
    */
    readonly property bool canScrollPrev: view.currentIndex > 0
    /*!
        \qmlproperty bool Carousel::canScrollNext
        Whether \l scrollNext() can advance (not on the last slide). Read-only.
    */
    readonly property bool canScrollNext: view.currentIndex < view.count - 1

    implicitWidth: 320
    implicitHeight: _horizontal ? 200 : 320

    /*!
        \qmlmethod Carousel::scrollPrev()
        Snap to the previous slide, if \l canScrollPrev.
    */
    function scrollPrev() { if (canScrollPrev) view.currentIndex-- }
    /*!
        \qmlmethod Carousel::scrollNext()
        Snap to the next slide, if \l canScrollNext.
    */
    function scrollNext() { if (canScrollNext) view.currentIndex++ }

    ObjectModel { id: itemsModel }

    ListView {
        id: view
        anchors.fill: parent
        clip: true
        model: itemsModel
        orientation: control._horizontal ? ListView.Horizontal : ListView.Vertical

        // align: "start" -- the current slide snaps to the viewport start and
        // scrolls smoothly; a drag settles onto the nearest slide.
        snapMode: ListView.SnapToItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: 0
        preferredHighlightEnd: 0
        highlightMoveDuration: 300
        highlight: null
        spacing: control.spacing        // Symmetric gap; does not offset content.
        boundsBehavior: Flickable.StopAtBounds

        // Consumed by CarouselItem to derive its sizing axis.
        property bool horizontalFlow: control._horizontal

        // Match the web component: Left/Right arrows map to prev/next on both axes.
        Keys.onLeftPressed: control.scrollPrev()
        Keys.onRightPressed: control.scrollNext()
    }

    // ==== Navigation buttons: outline, round, chevron glyph ====
    // (mirrors .cn-carousel-previous / .cn-carousel-next -> rounded-full)
    component NavButton: C.Button {
        id: nav
        property string glyph
        implicitWidth: 28
        implicitHeight: 28
        padding: 0
        hoverEnabled: true
        focusPolicy: Qt.StrongFocus
        opacity: enabled ? 1.0 : 0.5

        contentItem: Item {
            Icon {
                anchors.centerIn: parent
                name: nav.glyph
                size: 14
                color: Theme.foreground
            }
        }
        background: Rectangle {
            radius: width / 2
            color: nav.hovered ? Theme.alpha(Theme.input, 0.5) : Theme.alpha(Theme.input, 0)
            border.width: 1
            border.color: Theme.border
            Behavior on color { ColorAnimation { duration: Theme.durBase } }
            // Keyboard-only focus ring (focus-visible), gated on visualFocus.
            FocusRing { active: nav.visualFocus; targetRadius: nav.width / 2 }
        }
    }

    // Gap between a nav button and the content edge (mirrors -left-12/-right-12).
    readonly property real _navGap: Theme.space3   // 12

    NavButton {
        // Horizontal: centered outside the left edge; vertical: centered above
        // the top edge (chevron points up). Kept fully outside the content.
        glyph: control._horizontal ? "chevron-left" : "chevron-up"
        enabled: control.canScrollPrev
        onClicked: control.scrollPrev()
        x: control._horizontal ? -(width + control._navGap) : (control.width - width) / 2
        y: control._horizontal ? (control.height - height) / 2 : -(height + control._navGap)
    }

    NavButton {
        // Horizontal: centered outside the right edge; vertical: centered below
        // the bottom edge (chevron points down). Kept fully outside the content.
        glyph: control._horizontal ? "chevron-right" : "chevron-down"
        enabled: control.canScrollNext
        onClicked: control.scrollNext()
        x: control._horizontal ? control.width + control._navGap : (control.width - width) / 2
        y: control._horizontal ? (control.height - height) / 2 : control.height + control._navGap
    }
}
