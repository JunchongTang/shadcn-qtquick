import QtQuick
import QtQuick.Layouts
import LucideIcons

/*!
    \qmltype Pagination
    \inqmlmodule Shadcn
    \inherits RowLayout
    \brief A data-driven page navigator (Previous + numbered pages with
    ellipsis + Next).
    \image pagination.png


    Pagination is the compact page navigator styled after shadcn's base-mira
    \c .cn-pagination-* rules. Unlike the declarative React composition
    (\c PaginationLink / \c PaginationEllipsis / ...), this port is driven by two
    numbers: \l count (total pages) and \l page (the current page, 1-based). From
    those it lays out an optional \e Previous button, the page-number sequence
    (collapsed with ellipses when it would be too long), and an optional \e Next
    button.

    The current page is painted with the \c Button.Outline variant; the other
    page numbers use \c Button.Ghost. Clicking a page number or a Prev/Next
    button updates \l page and emits \l pageRequested; consumers can also treat
    the control as fully controlled by ignoring the local update and re-driving
    \l page from \l pageRequested.

    Layout follows the CSS tokens: content \c gap-0.5 (2px), each page/ellipsis
    cell \c size-7 (28px) with the ellipsis glyph at \c size-3.5 (14px), and the
    Previous / Next buttons keep full \c pl-2!/\c pr-2! (8px) padding on their
    icon side.

    \qml
    Pagination {
        count: 10
        page: 2
        onPageRequested: (p) => console.log("go to", p)
    }
    \endqml

    \sa Button
*/
RowLayout {
    id: control

    /*!
        \qmlproperty int Pagination::count
        The total number of pages. Clamped to at least 1. Defaults to 1.
    */
    property int count: 1
    /*!
        \qmlproperty int Pagination::page
        The current page, 1-based. Clamped to \c [1, count] when navigated
        via \l pageRequested. Defaults to 1.
    */
    property int page: 1
    /*!
        \qmlproperty int Pagination::siblingCount
        How many page numbers to show on each side of the current page
        before collapsing into an ellipsis. Defaults to 1.
    */
    property int siblingCount: 1
    /*!
        \qmlproperty bool Pagination::showPrevNext
        Whether to show the Previous / Next buttons. Defaults to true.
    */
    property bool showPrevNext: true
    /*!
        \qmlproperty bool Pagination::showPages
        Whether to show the numbered pages (false = Prev/Next only). Defaults to true.
    */
    property bool showPages: true
    /*!
        \qmlproperty string Pagination::previousText
        Label of the Previous button.
    */
    property string previousText: qsTr("Previous")
    /*!
        \qmlproperty string Pagination::nextText
        Label of the Next button.
    */
    property string nextText: qsTr("Next")

    /*!
        \qmlsignal Pagination::pageRequested(int page)
        Emitted whenever the user activates a page number or a Prev/Next button.
        \a page is the requested (already clamped) 1-based page. The local
        \l page is updated to this value before the signal is emitted, so a
        controlled parent may safely re-assign \l page in the handler.
    */
    signal pageRequested(int page)

    spacing: Theme.space0_5               // .cn-pagination-content: gap-0.5 = 2

    // Prev/Next enable state (exposed for reactivity and testing): Previous is
    // enabled while there is a page before the current one, Next while there is
    // a page after it.
    readonly property bool _canPrev: page > 1
    readonly property bool _canNext: page < count

    // Navigate to page p: clamp into [1, max(1, count)], update page if it
    // changed, then always emit pageRequested with the clamped target.
    function _goto(p) {
        let np = Math.min(Math.max(1, p), Math.max(1, count))
        if (np !== page)
            page = np
        pageRequested(np)
    }

    // Build the page sequence: an array mixing page numbers and the "ellipsis"
    // marker. This is the standard usePagination/DOTS algorithm: the first and
    // last pages are always shown; the current page and +/- siblingCount around
    // it are shown; when a gap remains toward either edge, an ellipsis is
    // inserted there.
    function _pages(total, current, sib) {
        total = Math.max(1, total)
        current = Math.min(Math.max(1, current), total)

        // No collapsing needed: first + last + current + 2*sib siblings + the
        // two ellipsis slots. If that already covers everything, show them all.
        var totalNumbers = sib * 2 + 5
        if (totalNumbers >= total)
            return _range(1, total)

        var leftSibling = Math.max(current - sib, 1)
        var rightSibling = Math.min(current + sib, total)
        var showLeftDots = leftSibling > 2
        var showRightDots = rightSibling < total - 1
        var edgeCount = 3 + 2 * sib

        if (!showLeftDots && showRightDots)
            return _range(1, edgeCount).concat(["ellipsis", total])
        if (showLeftDots && !showRightDots)
            return [1, "ellipsis"].concat(_range(total - edgeCount + 1, total))
        return [1, "ellipsis"].concat(_range(leftSibling, rightSibling))
                              .concat(["ellipsis", total])
    }

    // Inclusive integer range [start, end].
    function _range(start, end) {
        var r = []
        for (var i = start; i <= end; i++)
            r.push(i)
        return r
    }

    // The computed page sequence (numbers + "ellipsis" markers). Reactive on
    // count / page / siblingCount.
    readonly property var _items: _pages(count, page, siblingCount)

    // Exposed for testing: reach the page-cell delegates via itemAt(i).
    readonly property alias _pagesRepeater: pagesRepeater

    // ==== Previous ====
    Button {
        visible: control.showPrevNext
        variant: Button.Ghost
        size: Button.Default
        iconName: "chevron-left"
        text: control.previousText
        enabled: control._canPrev
        leftPadding: Theme.space2           // .cn-pagination-previous: pl-2!
        onClicked: control._goto(control.page - 1)
    }

    // ==== Page numbers (with ellipsis) ====
    Repeater {
        id: pagesRepeater
        model: control.showPages ? control._items : []
        delegate: Item {
            id: cell
            required property var modelData
            readonly property bool _isEllipsis: modelData === "ellipsis"
            // The current page is highlighted (outline). Exposed for testing.
            readonly property bool _active: !_isEllipsis && modelData === control.page
            // Exposed for testing: read the page button's variant/state.
            readonly property alias _button: pageBtn

            implicitWidth: 28               // size-7
            implicitHeight: 28

            // Ellipsis: size-7 container + svg size-3.5. Inherits foreground
            // (the .cn-pagination-ellipsis rule sets no color).
            LucideIcon {
                anchors.centerIn: parent
                visible: cell._isEllipsis
                name: "ellipsis"
                size: 14                    // svg size-3.5
                color: Theme.foreground
            }

            // Page button: current page -> outline, others -> ghost; square
            // size-7 with no horizontal padding so the number stays centered.
            Button {
                id: pageBtn
                anchors.fill: parent
                visible: !cell._isEllipsis
                variant: cell._active ? Button.Outline : Button.Ghost
                size: Button.Default
                text: cell._isEllipsis ? "" : String(cell.modelData)
                leftPadding: 0
                rightPadding: 0
                onClicked: control._goto(cell.modelData)
            }
        }
    }

    // ==== Next ====
    Button {
        visible: control.showPrevNext
        variant: Button.Ghost
        size: Button.Default
        trailingIconName: "chevron-right"
        text: control.nextText
        enabled: control._canNext
        rightPadding: Theme.space2          // .cn-pagination-next: pr-2!
        onClicked: control._goto(control.page + 1)
    }
}
