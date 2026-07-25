import QtQuick

/*!
    \qmltype Separator
    \inqmlmodule Shadcn
    \inherits Rectangle
    \brief A thin 1px divider line, horizontal or vertical.

    Separator is a port of shadcn's base-mira \c .cn-separator (Base UI
    \c Separator primitive). It renders a single 1px line filled with the
    \c border token: the reference applies \c bg-border with
    \c data-horizontal:h-px / \c data-vertical:w-px, so the line is always 1px
    on its thin axis regardless of \l orientation.

    The long axis has no intrinsic length in the web original (\c w-full /
    \c self-stretch make it fill the flex parent). QML has no equivalent
    auto-stretch, so this component exposes a 100px implicit length as a
    sensible default; place it in a layout and set \c Layout.fillWidth (for a
    horizontal separator) or \c Layout.fillHeight (for a vertical one), or an
    explicit \c width / \c height, to span its container.

    \qml
    // Horizontal rule that spans its column.
    Separator { Layout.fillWidth: true }

    // Vertical rule between two inline items, matched to their height.
    Separator { orientation: Separator.Vertical; height: 20 }
    \endqml

    \sa ItemSeparator, MenuSeparator
*/
Rectangle {
    /*!
        \qmlproperty enumeration Separator::orientation
        The axis the divider runs along; see \l orientation.
        \value Separator.Horizontal A left-to-right rule: 1px tall, spans its
               width. This is the default.
        \value Separator.Vertical A top-to-bottom rule: 1px wide, spans its
               height.

        \note The member names \c Horizontal and \c Vertical do not collide with
        the \c Item.TransformOrigin enum inherited via \l Rectangle (whose
        members are \c Top / \c Left / \c Center / \c Right / \c Bottom and the
        corner variants), so the flattened enum values stay 0 / 1 as declared.
        Renaming the way HoverCard's \c Side had to (issue #029) is unnecessary
        here.
    */
    enum Orientation { Horizontal, Vertical }

    /*!
        \qmlproperty int Separator::orientation
        The divider axis; see \l Orientation. Defaults to \c Separator.Horizontal.
    */
    property int orientation: Separator.Horizontal

    // bg-border: the divider is filled with the border token (no border/radius).
    color: Theme.border

    // 1px on the thin axis (h-px / w-px); 100px default length on the long axis.
    implicitWidth: orientation === Separator.Vertical ? 1 : 100
    implicitHeight: orientation === Separator.Vertical ? 100 : 1
}
