import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import LucideIcons
import Shadcn

// date-picker-with-presets composition: quick presets + a calendar inside the
// popover. Uses the raw Popover + Calendar combination (not the DatePicker
// convenience type) so the preset row can be injected above the calendar.
// Presets (Today / Tomorrow / In 3 days / In a week) use ghost buttons in place
// of the official Select.
C.AbstractButton {
    id: trigger

    property var selectedDate: undefined
    readonly property bool _empty: selectedDate === undefined
    function _format(d) { return d === undefined ? "" : Qt.formatDate(d, "MMMM d, yyyy") }
    function _addDays(n) {
        var d = new Date()
        d.setHours(0, 0, 0, 0)
        d.setDate(d.getDate() + n)
        return d
    }
    function _pick(d) {
        selectedDate = d
        cal.selectedDate = d
        cal.displayMonth = d
        pop.close()
    }

    width: 240
    implicitHeight: 28
    hoverEnabled: true
    padding: 0
    leftPadding: Theme.space2_5
    rightPadding: Theme.space2_5

    // Toggle the popover with a reopen guard; see src/DatePicker.qml.
    property double _lastPopClose: 0
    onClicked: {
        if (pop.opened) { pop.close(); return }
        if (Date.now() - trigger._lastPopClose < 250) return
        pop.open()
    }
    Connections {
        target: pop
        function onOpenedChanged() { if (!pop.opened) trigger._lastPopClose = Date.now() }
    }

    contentItem: RowLayout {
        spacing: Theme.space2
        Text {
            Layout.fillWidth: true
            text: trigger._empty ? "Pick a date" : trigger._format(trigger.selectedDate)
            color: trigger._empty ? Theme.mutedForeground : Theme.foreground
            font.pixelSize: Theme.textXs
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
        LucideIcon { name: "chevron-down"; size: 14; color: Theme.mutedForeground; opacity: 0.5 }
    }

    background: Rectangle {
        id: bg
        radius: Theme.radiusMd
        color: trigger.hovered ? Theme.alpha(Theme.input, 0.5) : "transparent"
        border.width: 1
        border.color: trigger.activeFocus ? Theme.ring : Theme.border
        Behavior on color { ColorAnimation { duration: Theme.durBase } }
        FocusRing { active: trigger.activeFocus; targetRadius: bg.radius }
    }

    Popover {
        id: pop
        align: Popover.Align.Start
        padding: 0
        width: cal.implicitWidth
        height: presetCol.implicitHeight

        ColumnLayout {
            id: presetCol
            spacing: Theme.space2         // flex-col space-y-2
            width: cal.implicitWidth

            // Preset shortcuts (px-2 pt-2)
            ColumnLayout {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.space2
                Layout.rightMargin: Theme.space2
                Layout.topMargin: Theme.space2
                spacing: Theme.space1
                Repeater {
                    model: [
                        { label: qsTr("Today"), days: 0 },
                        { label: qsTr("Tomorrow"), days: 1 },
                        { label: qsTr("In 3 days"), days: 3 },
                        { label: qsTr("In a week"), days: 7 }
                    ]
                    delegate: Button {
                        required property var modelData
                        Layout.fillWidth: true
                        variant: Button.Ghost
                        size: Button.Sm
                        text: modelData.label
                        onClicked: trigger._pick(trigger._addDays(modelData.days))
                    }
                }
            }

            // Calendar (rounded-md border)
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: cal.implicitHeight
                radius: Theme.radiusMd
                color: "transparent"
                border.width: 1
                border.color: Theme.border
                Calendar {
                    id: cal
                    anchors.centerIn: parent
                    onSelected: function(d) { trigger._pick(d) }
                }
            }
        }
    }
}
