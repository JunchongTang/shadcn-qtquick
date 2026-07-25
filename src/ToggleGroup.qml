import QtQuick
import QtQuick.Layouts

/*!
    \qmltype ToggleGroup
    \inqmlmodule Shadcn
    \inherits GridLayout
    \brief A set of two-state buttons that share styling and selection.

    ToggleGroup lays out \l ToggleGroupItem children and propagates \l variant and
    \l size down to them. \l multiple chooses between single-selection (mutually
    exclusive, the default) and multi-selection. A disabled group disables its items.

    \l spacing is expressed in shadcn spacing units (multiplied by 4 to get pixels);
    it defaults to 2 (8px). \l orientation lays the items out in a row or a column.

    \qml
    ToggleGroup {
        ToggleGroupItem { iconName: "bold" }
        ToggleGroupItem { iconName: "italic" }
        ToggleGroupItem { iconName: "underline" }
    }
    \endqml

    \sa ToggleGroupItem, Toggle
*/
GridLayout {
    id: group

    // Visual style (documented on the variant property).
    enum Variant { Default, Outline }

    // Compact size scale (documented on the size property). Default is listed
    // first so it shares value 0 with Variant's Default; QML flattens enum values
    // into the type scope, so a colliding name must resolve to the same number in both enums.
    enum Size { Default, Sm, Lg }

    // Layout direction (documented on the orientation property).
    enum Orientation { Horizontal, Vertical }

    /*!
        \qmlproperty enumeration ToggleGroup::variant
        Variant propagated to items.

        \value ToggleGroup.Default Transparent items.
        \value ToggleGroup.Outline Outlined items.
    */
    property int variant: ToggleGroup.Default
    /*!
        \qmlproperty enumeration ToggleGroup::size
        Size propagated to items.

        \value ToggleGroup.Default 28px items.
        \value ToggleGroup.Sm 24px items.
        \value ToggleGroup.Lg 32px items.
    */
    property int size: ToggleGroup.Default
    /*!
        \qmlproperty int ToggleGroup::spacing
        Gap between items in shadcn units (×4 = px). Defaults to 2 (8px).
    */
    property int spacing: 2
    /*!
        \qmlproperty enumeration ToggleGroup::orientation
        Layout direction.

        \value ToggleGroup.Horizontal Single row.
        \value ToggleGroup.Vertical Single column.
    */
    property int orientation: ToggleGroup.Horizontal
    /*!
        \qmlproperty bool ToggleGroup::multiple
        If \c false (default) selection is mutually exclusive; if \c true multiple items may be on.
    */
    property bool multiple: false

    flow: orientation === ToggleGroup.Vertical ? GridLayout.TopToBottom : GridLayout.LeftToRight
    rows: orientation === ToggleGroup.Vertical ? -1 : 1
    columns: orientation === ToggleGroup.Vertical ? 1 : -1
    rowSpacing: spacing * 4
    columnSpacing: spacing * 4

    // Single-selection: when an item turns on, turn the others off. No-op in multiple mode.
    function _onItemToggled(item) {
        if (multiple || !item.checked)
            return
        for (var i = 0; i < children.length; i++) {
            var c = children[i]
            if (c !== item && c.checkable === true && c.checked)
                c.checked = false
        }
    }
}
