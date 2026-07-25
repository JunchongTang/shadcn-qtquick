import QtQuick
import QtQuick.Layouts

/*!
    \qmltype TypographyList
    \inqmlmodule Shadcn
    \inherits ColumnLayout
    \brief A bulleted list, styled after shadcn's base-mira \c list.

    TypographyList renders shadcn's unordered \c list prose style:
    \c ml-6 (24px left indent), \c list-disc (a solid bullet before each item)
    and \c {[&>li]:mt-2} (8px between items). Each item is 16px
    (\c text-base) \l {Theme::foreground}{foreground} text. Outer spacing
    (\c my-6) is left to the surrounding layout.

    \qmlproperty list<string> TypographyList::items
    The list item strings, one bullet per entry.

    \qml
    TypographyList {
        items: ["1st level of puns", "2nd level of jokes"]
    }
    \endqml
*/
ColumnLayout {
    id: root

    // List item strings; one bullet row is created per entry.
    property var items: []

    Layout.fillWidth: true
    Layout.leftMargin: 24                // ml-6
    spacing: 8                           // [&>li]:mt-2

    Repeater {
        model: root.items
        delegate: RowLayout {
            id: liRow
            required property string modelData
            Layout.fillWidth: true
            spacing: 8

            // Solid bullet marker (list-disc), top-aligned with the item text.
            Text {
                Layout.alignment: Qt.AlignTop
                text: "•"
                color: Theme.foreground
                font.family: Theme.fontSans
                font.pixelSize: Theme.textBase
                lineHeight: 1.6
                lineHeightMode: Text.ProportionalHeight
            }
            Text {
                Layout.fillWidth: true
                text: liRow.modelData
                color: Theme.foreground
                font.family: Theme.fontSans
                font.pixelSize: Theme.textBase
                lineHeight: 1.6
                lineHeightMode: Text.ProportionalHeight
                wrapMode: Text.Wrap
                textFormat: Text.PlainText
            }
        }
    }
}
