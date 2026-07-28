import QtQuick
import QtQuick.Layouts

/*!
    \qmltype ComboboxChip
    \inqmlmodule Shadcn
    \inherits Item
    \brief A single selected-value tag inside a multiple-select Combobox trigger.

    ComboboxChip renders one "selected item" tag (a small rounded block with an
    optional trailing remove button), matching the base-mira \c .cn-combobox-chip:
    \c bg-muted-foreground/10, \c text-foreground, height 19 (h-[4.75]), \c gap-1,
    \c px-1.5, \c {rounded-[calc(--radius-sm - 2px)]}, \c text-xs, \c font-medium and
    \c whitespace-nowrap. When the remove button is present the right padding
    collapses to 0 (\c {has-remove:pr-0}). The remove button (\c .cn-combobox-chip-remove)
    uses \c -ml-1 and \c opacity-50, going to full opacity on hover.
*/
Item {
    id: chip

    /*! \qmlproperty string ComboboxChip::text
        Label shown in the chip. */
    property string text: ""

    /*! \qmlproperty bool ComboboxChip::removable
        Whether to show the trailing remove button. Defaults to \c true. */
    property bool removable: true

    /*! \qmlsignal ComboboxChip::removed()
        Emitted when the remove button is tapped. */
    signal removed()

    readonly property real _padLeft: Theme.space1_5                          // px-1.5
    readonly property real _padRight: removable ? 0 : Theme.space1_5         // has-remove:pr-0

    implicitHeight: 19                                                       // h-[calc(--spacing(4.75))]
    implicitWidth: _padLeft + row.implicitWidth + _padRight

    Rectangle {
        anchors.fill: parent
        radius: Math.max(0, Theme.radiusSm - 2)                             // rounded-[calc(radius-sm - 2px)]
        color: Theme.alpha(Theme.mutedForeground, 0.1)                      // bg-muted-foreground/10
    }

    RowLayout {
        id: row
        anchors.left: parent.left
        anchors.leftMargin: chip._padLeft
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.space1                                               // gap-1

        Text {
            text: chip.text
            color: Theme.foreground
            font.pixelSize: Theme.textXs
            font.weight: Font.Medium
        }

        // Remove button (x): -ml-1 cancels gap-1 to pull it close to the label;
        // opacity 50 -> 100 on hover.
        Item {
            visible: chip.removable
            Layout.preferredWidth: 14
            Layout.preferredHeight: 14
            Layout.leftMargin: -Theme.space1                                // -ml-1
            Icon {
                anchors.centerIn: parent
                name: "x"
                size: 12
                color: Theme.foreground
                opacity: rm.hovered ? 1.0 : 0.5
            }
            HoverHandler { id: rm; cursorShape: Qt.PointingHandCursor }
            TapHandler { onTapped: chip.removed() }
        }
    }
}
