import QtQuick

/*!
    \qmltype TableColumn
    \inqmlmodule Shadcn
    \inherits QtObject
    \brief A declarative column definition for \l Table.

    TableColumn is used as an element of \l {Table::columnItems}{Table.columnItems},
    the declarative alternative to the JS \l {Table::columns}{columns} array. Its
    properties map one-to-one to the fields of a JS column object, so the two
    styles are interchangeable.

    \qml
    Table {
        model: [ … ]
        columnItems: [
            TableColumn { title: "Status"; key: "status"; width: 150 },
            TableColumn { title: "Email";  key: "email" },              // no width -> fills
            TableColumn { title: "Amount"; key: "amount"; width: 120; align: Qt.AlignRight
                          medium: true; format: v => "$" + v.toFixed(2) }
        ]
    }
    \endqml

    \sa Table
*/
QtObject {
    /*! \qmlproperty string TableColumn::title
        Header label for the column. */
    property string title: ""
    /*! \qmlproperty string TableColumn::key
        Field read from the row object in JS-array model mode. */
    property string key: ""
    /*! \qmlproperty string TableColumn::role
        Role read in item-model mode (empty -> \c "display"). */
    property string role: ""
    /*! \qmlproperty real TableColumn::width
        Fixed width when \c {> 0}; otherwise the column fills the remaining space. */
    property real width: 0
    /*! \qmlproperty bool TableColumn::fillWidth
        Force the column to fill even when a \l width is set. */
    property bool fillWidth: false
    /*! \qmlproperty real TableColumn::minWidth
        Lower clamp on the resolved width; \c 0 means unbounded. */
    property real minWidth: 0
    /*! \qmlproperty real TableColumn::maxWidth
        Upper clamp on the resolved width; \c 0 means unbounded. */
    property real maxWidth: 0
    /*! \qmlproperty int TableColumn::align
        Horizontal text alignment (\c Text.AlignLeft / \c AlignRight / \c AlignHCenter). */
    property int align: Text.AlignLeft
    /*! \qmlproperty var TableColumn::format
        Optional \c {function(value) -> string} formatting the cell value. */
    property var format: null
    /*! \qmlproperty bool TableColumn::medium
        Render the cell text with a medium (bold) weight. */
    property bool medium: false
    /*! \qmlproperty Component TableColumn::cellDelegate
        Optional custom cell renderer. Inside it, \c parent exposes \c value,
        \c row, \c rowData and \c table. */
    property Component cellDelegate: null
    /*! \qmlproperty Component TableColumn::headerDelegate
        Optional custom header renderer. Inside it, \c parent exposes \c column
        and \c table. */
    property Component headerDelegate: null
}
