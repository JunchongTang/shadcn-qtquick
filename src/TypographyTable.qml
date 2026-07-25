pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

/*!
    \qmltype TypographyTable
    \inqmlmodule Shadcn
    \inherits ColumnLayout
    \brief A markdown-style prose table, styled after shadcn's base-mira
    \c table.

    TypographyTable renders shadcn's markdown \c table prose style (not the
    interactive data table): every cell has a 1px \l {Theme::border}{border}
    with \c px-4 (16px) / \c py-2 (8px) padding and left-aligned 16px text;
    header cells are \c font-bold. Body rows follow the \c even:bg-muted rule,
    which is scoped per \c tbody: because the header lives in its own \c thead
    it is never shaded, and inside the body the second row (\c nth-child(2),
    zero-based index 1) gets the \l {Theme::muted}{muted} background. Columns
    are distributed evenly. Outer spacing (\c my-6) is left to the surrounding
    layout.

    \qmlproperty list<string> TypographyTable::headers
    The header cell labels, one column per entry.

    \qmlproperty list<var> TypographyTable::rows
    The body rows; each entry is an array of cell strings.

    \qml
    TypographyTable {
        headers: ["King's Treasury", "People's happiness"]
        rows: [["Empty", "Overflowing"], ["Modest", "Satisfied"]]
    }
    \endqml
*/
ColumnLayout {
    id: root

    // Header cell labels (one column each).
    property var headers: []
    // Body rows; each entry is an array of cell strings.
    property var rows: []

    Layout.fillWidth: true
    spacing: 0

    // A single bordered cell with px-4 / py-2 padding.
    component Cell: Rectangle {
        property string content: ""
        property bool header: false
        property color fill: "transparent"

        Layout.fillWidth: true
        Layout.preferredWidth: 1          // equal-width columns
        implicitHeight: cellText.implicitHeight + 16   // py-2: 8px top + 8px bottom
        color: fill
        border.width: 1
        border.color: Theme.border

        Text {
            id: cellText
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 16        // px-4
            anchors.rightMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            text: parent.content
            color: Theme.foreground
            font.family: Theme.fontSans
            font.pixelSize: Theme.textBase
            font.weight: parent.header ? Font.Bold : Font.Normal   // th font-bold
            horizontalAlignment: Text.AlignLeft                    // text-left
            wrapMode: Text.Wrap
            textFormat: Text.PlainText
        }
    }

    // Header row (thead): never shaded.
    RowLayout {
        Layout.fillWidth: true
        spacing: 0
        Repeater {
            model: root.headers
            delegate: Cell {
                required property string modelData
                content: modelData
                header: true
            }
        }
    }

    // Body rows (tbody): even:bg-muted, scoped to the body (index 1, 3, ...).
    Repeater {
        model: root.rows
        delegate: RowLayout {
            id: bodyRow
            required property int index
            required property var modelData
            Layout.fillWidth: true
            spacing: 0
            Repeater {
                model: bodyRow.modelData
                delegate: Cell {
                    required property string modelData
                    content: modelData
                    fill: (bodyRow.index % 2 === 1) ? Theme.muted : "transparent"
                }
            }
        }
    }
}
