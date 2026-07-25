import QtQuick
import QtQuick.Layouts
import LucideIcons

/*!
    \qmltype Alert
    \inqmlmodule Shadcn
    \inherits Rectangle
    \brief A callout box with an optional leading icon, title, description and action slot.

    Alert reproduces shadcn's base-mira \c .cn-alert rules: a \c rounded-lg
    bordered card with \c px-2 \c py-1.5 padding, an optional leading icon, a
    medium-weight title, a muted description, and an optional right-aligned
    action slot (typically a \l Button).

    The visual style is driven by \l variant. The \c Default variant paints a
    card surface with card-foreground text; \c Destructive keeps the card
    surface but tints the title (and, at 90% opacity, the description) with the
    destructive color. The individual color roles (\l surface, \l stroke,
    \l titleColor, \l descColor) are exposed so a custom palette can be applied
    (as in the "colors" example) without changing the variant.

    Content items assigned as children populate the trailing action slot via the
    default property, so a plain child \l Button becomes the alert action.

    \qml
    // Basic
    Alert {
        iconName: "circle-check"
        title: "Account updated successfully"
        description: "Your profile information has been saved."
    }

    // Destructive
    Alert {
        variant: Alert.Destructive
        iconName: "circle-alert"
        title: "Payment failed"
        description: "Your payment could not be processed."
    }

    // With action
    Alert {
        title: "Dark mode is now available"
        description: "Enable it under your profile settings to get started."
        Button { size: Button.Xs; text: "Enable" }
    }
    \endqml
*/
Rectangle {
    id: control

    // Visual style. Default is first so it holds value 0; Alert declares only this
    // enum, so no cross-enum member-name collision (issue #028 does not apply here).
    enum Variant { Default, Destructive }

    /*!
        \qmlproperty enumeration Alert::variant
        The visual style. Defaults to \c Alert.Default.

        \value Alert.Default Card surface with card-foreground title and muted description.
        \value Alert.Destructive Card surface with destructive-tinted title and description.
    */
    property int variant: Alert.Default
    /*!
        \qmlproperty string Alert::title
        Title text; the title row is hidden when empty.
    */
    property string title: ""
    /*!
        \qmlproperty string Alert::description
        Description text; the description row is hidden when empty.
    */
    property string description: ""
    /*!
        \qmlproperty string Alert::iconName
        Optional leading Lucide icon (kebab-case name); the icon is hidden when empty.
    */
    property string iconName: ""

    /*!
        \qmlproperty color Alert::surface
        Background fill. Defaults to the card token.
    */
    property color surface: Theme.card
    /*!
        \qmlproperty color Alert::stroke
        Border color. Defaults to the border token.
    */
    property color stroke: Theme.border
    /*!
        \qmlproperty color Alert::titleColor
        Title and icon color. Defaults per \l variant (card-foreground / destructive).
    */
    property color titleColor: variant === Alert.Destructive ? Theme.destructive : Theme.cardForeground
    /*!
        \qmlproperty color Alert::descColor
        Description color. Defaults per \l variant (muted-foreground / destructive at 90%).
    */
    property color descColor: variant === Alert.Destructive
                              ? Theme.alpha(Theme.destructive, 0.9) : Theme.mutedForeground

    /*!
        \qmlproperty list<QtObject> Alert::action
        \qmldefault
        Trailing action slot. Child items (typically a \l Button) are placed at
        the right of the alert, top-aligned. The slot is hidden when empty.
    */
    default property alias action: actionSlot.data

    implicitWidth: 400
    // Content height plus py-1.5 top and bottom.
    implicitHeight: row.implicitHeight + Theme.space1_5 * 2
    radius: Theme.radiusLg          // rounded-lg
    color: surface
    border.width: 1                 // border
    border.color: stroke

    RowLayout {
        id: row
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: Theme.space2        // px-2
        anchors.rightMargin: Theme.space2       // px-2
        anchors.topMargin: Theme.space1_5       // py-1.5
        spacing: Theme.space1_5                 // gap-x-1.5 between icon and text

        // Leading icon; spans the title+description block, nudged down 2px
        // (translate-y-0.5) to align with the first text baseline.
        LucideIcon {
            visible: control.iconName !== ""
            name: control.iconName
            size: 14                            // size-3.5
            color: control.titleColor           // text-current
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 2
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2                           // gap-0.5 between title and description
            Text {
                visible: control.title !== ""
                text: control.title
                color: control.titleColor
                font.pixelSize: Theme.textXs     // text-xs
                font.weight: Font.Medium         // font-medium
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
            Text {
                visible: control.description !== ""
                Layout.fillWidth: true
                text: control.description
                color: control.descColor
                font.pixelSize: Theme.textXs     // text-xs
                lineHeight: Theme.lineRelaxed    // /relaxed line height
                lineHeightMode: Text.ProportionalHeight
                wrapMode: Text.Wrap
            }
        }

        // Trailing action slot (e.g. a Button), top-aligned.
        Item {
            id: actionSlot
            visible: children.length > 0
            Layout.alignment: Qt.AlignTop
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }
    }
}
