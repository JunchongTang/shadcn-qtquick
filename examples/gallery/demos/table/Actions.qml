import QtQuick
import Shadcn

// 行内操作(新 Table)—— 每行末列一个 ghost IconButton 触发 DropdownMenu(cellDelegate)。
Table {
    id: root
    width: 480
    property bool fillCard: true

    columns: [
        { title: qsTr("Product"), key: "product", medium: true },
        { title: qsTr("Price"),   key: "price" },
        { title: qsTr("Actions"), key: "",       width: 90, align: Qt.AlignRight, cellDelegate: actionsCell }
    ]
    model: [
        { product: "Wireless Mouse",      price: "$29.99"  },
        { product: "Mechanical Keyboard", price: "$129.99" },
        { product: "USB-C Hub",           price: "$49.99"  }
    ]

    Component {
        id: actionsCell
        Item {
            IconButton {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                variant: IconButton.Ghost
                iconName: "ellipsis"
                onClicked: rowMenu.popup(0, height + 4)
                Menu {
                    id: rowMenu
                    MenuItem { text: qsTr("Edit"); iconName: "pencil" }
                    MenuItem { text: qsTr("Duplicate"); iconName: "copy" }
                    MenuSeparator {}
                    MenuItem { text: qsTr("Delete"); iconName: "trash-2"; destructive: true }
                }
            }
        }
    }
}
