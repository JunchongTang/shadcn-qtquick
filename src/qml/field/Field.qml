import QtQuick
import QtQuick.Layouts

/*!
    \qmltype Field
    \inqmlmodule Shadcn
    \inherits GridLayout
    \brief A single form field container (role="group") that arranges a label,
    control, description and error with a configurable orientation.
    \image field.png


    The field switches between a single column (vertical) and a single row
    (horizontal) via \l flow / \l rows / \l columns, so the orientation can
    change without swapping the base type at runtime. Children are spaced with
    gap-2. In the error state (\l invalid) the child label/title bindings may
    turn destructive; \l FieldError is always destructive.
*/
GridLayout {
    id: field

    enum Orientation { Vertical, Horizontal, Responsive }

    /*!
        \qmlproperty enumeration Field::orientation
        Arrangement of the field's children.

        \value Field.Vertical Stack children in one column (default); children fill width.
        \value Field.Horizontal Place children in one row, vertically centred.
        \value Field.Responsive Container-query adaptive on the web; simplified to
               horizontal here (the gallery is wide enough to always use a row).
    */
    property int orientation: Field.Vertical
    /*!
        \qmlproperty bool Field::invalid
        When true the field is in the error state.
    */
    // Error state: bound children (FieldLabel/FieldTitle/FieldDescription) may
    // turn destructive; FieldError is always destructive.
    property bool invalid: false

    /*!
        \qmlproperty bool Field::horizontal
        \readonly
        True when \l orientation is Horizontal or Responsive.
    */
    // Responsive is simplified to a row (see the type brief).
    readonly property bool horizontal: orientation === Field.Horizontal
                                       || orientation === Field.Responsive

    Layout.fillWidth: true
    flow: horizontal ? GridLayout.TopToBottom : GridLayout.LeftToRight
    rows: horizontal ? 1 : -1
    columns: horizontal ? -1 : 1
    rowSpacing: Theme.space2        // gap-2
    columnSpacing: Theme.space2
}
