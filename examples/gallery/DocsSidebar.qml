import QtQuick
import QtQuick.Layouts
import Shadcn

// Docs site left navigation — lists components, highlights the current one, dims unimplemented ones and marks them "soon".
// Keyboard navigable: while the ListView has focus, ↑/↓ move the cursor and Enter/Space open the current item; keyboard-focused row shows a focus ring.
// The selected page (currentId) is highlighted with accent; the keyboard cursor (currentIndex) has its own focus ring — the two are independent.
Item {
    id: root

    property var model: []
    property string currentId: ""
    signal itemClicked(var item)

    // Expose the internal ListView so callers can set initial focus (makes site-wide keyboard navigation work from a cold start).
    property alias listView: list

    function _indexOf(id) {
        for (var i = 0; i < root.model.length; i++)
            if (root.model[i].id === id) return i
        return -1
    }
    function _activateCurrent() {
        if (list.currentIndex >= 0 && list.currentIndex < root.model.length)
            root.itemClicked(root.model[list.currentIndex])
    }
    // When the selected page changes, sync the keyboard cursor to that item.
    onCurrentIdChanged: list.currentIndex = _indexOf(currentId)
    Component.onCompleted: list.currentIndex = _indexOf(currentId)

    // border-r
    Rectangle {
        anchors.right: parent.right
        height: parent.height
        width: 1
        color: Theme.border
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 12          // Content left padding (matches the official sidebar, avoids hugging the window's left edge)
        anchors.rightMargin: 1
        spacing: 0

        Text {
            Layout.leftMargin: 6
            Layout.topMargin: 16
            Layout.bottomMargin: 4
            text: qsTr("Components")
            color: Theme.foreground
            font.pixelSize: Theme.textXs
            font.weight: Font.DemiBold
        }

        ListView {
            id: list
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: root.model
            spacing: 2
            boundsBehavior: Flickable.StopAtBounds
            activeFocusOnTab: true            // Join the Tab chain
            keyNavigationEnabled: true        // ↑/↓ move the cursor
            keyNavigationWraps: false
            highlightMoveDuration: 0
            highlight: null
            bottomMargin: 16

            // Keyboard activation: Enter/Return/Space open the current cursor item.
            Keys.onReturnPressed: root._activateCurrent()
            Keys.onEnterPressed: root._activateCurrent()
            Keys.onSpacePressed: root._activateCurrent()

            delegate: Item {
                id: navItem
                required property int index
                required property var modelData
                width: ListView.view.width - 16
                x: 8
                implicitHeight: 28

                readonly property bool selected: navItem.modelData.id === root.currentId
                readonly property bool implemented: navItem.modelData.page !== ""
                // Keyboard focus: the list has focus and the cursor is on this row.
                readonly property bool kbFocused: list.activeFocus && list.currentIndex === navItem.index

                Rectangle {
                    id: bg
                    anchors.fill: parent
                    radius: Theme.radiusMd
                    color: navItem.selected ? Theme.accent
                         : hover.hovered ? Theme.alpha(Theme.accent, 0.6) : "transparent"
                    FocusRing { active: navItem.kbFocused; targetRadius: bg.radius }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 6

                    Text {
                        Layout.fillWidth: true
                        text: navItem.modelData.label
                        color: navItem.selected ? Theme.accentForeground
                             : navItem.implemented ? Theme.foreground : Theme.mutedForeground
                        font.pixelSize: Theme.textXs
                        font.weight: navItem.selected ? Font.Medium : Font.Normal
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text {
                        visible: !navItem.implemented
                        text: qsTr("soon")
                        color: Theme.mutedForeground
                        font.pixelSize: 9
                        opacity: 0.7
                    }
                }

                HoverHandler { id: hover }
                TapHandler {
                    // Mouse click: only select, don't grab focus → mouse actions don't trigger the keyboard focus ring (focus-visible is keyboard-only).
                    onTapped: {
                        list.currentIndex = navItem.index
                        root.itemClicked(navItem.modelData)
                    }
                }
            }
        }
    }
}
