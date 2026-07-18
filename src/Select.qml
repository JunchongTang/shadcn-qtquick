import QtQuick
import QtQuick.Controls.Basic as C
import LucideIcons

// shadcn Select —— 触发器(trigger)+ 弹出列表(popover)。
// 文件名 Select 与基类 ComboBox 大小写不同,无需别名。用标准 model/currentIndex API。
C.ComboBox {
    id: control

    implicitHeight: 28
    leftPadding: Theme.space3
    rightPadding: Theme.space3 + 14 + Theme.space2 // 给右侧 chevron 留位
    font.pixelSize: Theme.textXs
    hoverEnabled: true
    opacity: enabled ? 1.0 : 0.5

    // ==== 触发器文字 ====
    contentItem: Text {
        text: control.displayText
        font: control.font
        color: Theme.foreground
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    // ==== 右侧 chevron ====
    indicator: LucideIcon {
        x: control.width - width - Theme.space3
        y: (control.height - height) / 2
        name: "chevrons-up-down"
        size: 14
        color: Theme.mutedForeground
    }

    // ==== 触发器背景 + 焦点外圈 ====
    background: Rectangle {
        id: bg
        radius: Theme.radiusMd
        color: "transparent"
        border.width: 1
        border.color: control.activeFocus ? Theme.ring : Theme.border
        Behavior on border.color { ColorAnimation { duration: Theme.durFast } }

        Rectangle {
            anchors.fill: parent
            anchors.margins: -Theme.ringWidth
            radius: bg.radius + Theme.ringWidth
            color: "transparent"
            border.width: Theme.ringWidth
            border.color: Theme.alpha(Theme.ring, Theme.ringOpacity)
            visible: control.activeFocus
            z: -1
        }
    }

    // ==== 列表项 delegate ====
    delegate: C.ItemDelegate {
        id: item
        required property int index
        required property var model
        width: ListView.view ? ListView.view.width : control.width
        height: 28
        padding: 0
        hoverEnabled: true

        readonly property bool _selected: control.currentIndex === index

        contentItem: Item {
            Text {
                anchors.left: parent.left
                anchors.leftMargin: Theme.space3
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - Theme.space3 * 2 - 14
                text: item.model[control.textRole] !== undefined
                      ? item.model[control.textRole] : item.model.modelData
                font.pixelSize: Theme.textXs
                color: Theme.foreground
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
            // 选中项右侧 check。
            LucideIcon {
                anchors.right: parent.right
                anchors.rightMargin: Theme.space3
                anchors.verticalCenter: parent.verticalCenter
                name: "check"
                size: 14
                color: Theme.foreground
                visible: item._selected
            }
        }

        background: Rectangle {
            radius: Theme.radiusSm
            color: item.hovered ? Theme.accent : "transparent"
        }
    }

    // ==== 弹出层(popover surface)====
    popup: C.Popup {
        y: control.height + Theme.space1
        width: control.width
        implicitHeight: Math.min(contentItem.implicitHeight + 2 * padding, 300)
        padding: Theme.space1

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
            boundsBehavior: Flickable.StopAtBounds
            C.ScrollIndicator.vertical: C.ScrollIndicator {}
        }

        background: Rectangle {
            radius: Theme.radiusMd
            color: Theme.popover
            border.width: 1
            border.color: Theme.border
            // 轻微阴影。
            Rectangle {
                anchors.fill: parent
                anchors.margins: -1
                radius: parent.radius + 1
                color: "transparent"
                border.width: 1
                border.color: Theme.alpha(Theme.foreground, 0.06)
                z: -1
            }
        }
    }
}
