import QtQuick
import QtTest
import Shadcn

// Theme.popupsUseWindows decides whether a dropdown opens inside the window
// that hosts it or in one of its own. The difference is only visible at a
// window edge, so the check puts a select near the bottom of a deliberately
// short window and asks where the list actually lands on screen.
Item {
    id: root
    width: 400
    height: 300

    Component {
        id: hostComponent
        Window {
            x: 200
            y: 200
            width: 340
            height: 160
            visible: true

            property alias select: picker

            Select {
                id: picker
                y: 160 - 44                 // a field's height above the bottom edge
                width: 150
                model: ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
            }
        }
    }

    TestCase {
        name: "PopupWindows"
        when: windowShown

        // Theme is a singleton: a case that writes it leaks into the ones that
        // follow, and QuickTest runs them in alphabetical order.
        function cleanup() {
            Theme.popupsUseWindows = false
        }

        function test_default_keeps_popups_in_the_scene() {
            compare(Theme.popupsUseWindows, false)
        }

        function test_placement_data() {
            return [
                { tag: "in the scene", useWindows: false, ownWindow: false },
                { tag: "own window",   useWindows: true,  ownWindow: true },
            ]
        }

        function test_placement(data) {
            Theme.popupsUseWindows = data.useWindows

            const host = createTemporaryObject(hostComponent, root)
            verify(host)
            verify(waitForRendering(host.contentItem))

            const popup = host.select.popup
            popup.open()
            tryVerify(() => popup.opened, 2000)
            wait(120)                       // let the window settle where it lands

            const popupWindow = popup.contentItem.Window.window
            verify(popupWindow, "the popup should be in some window once open")

            const inOwnWindow = popupWindow !== host
            if (data.ownWindow && !inOwnWindow) {
                // resolvedPopupType() falls back to Item unless the platform
                // reports MultipleWindows. Skipping says so; passing would claim
                // a placement that never happened.
                skip("this platform will not give a popup a window of its own")
            }
            compare(inOwnWindow, data.ownWindow)

            const top = popup.contentItem.mapToGlobal(0, 0).y
            const past = top + popup.height - (host.y + host.height)

            if (data.ownWindow) {
                verify(past > 0,
                       "a dropdown in its own window should open downward past the "
                       + "window edge, but it ended " + Math.round(past) + "px short")
            } else {
                verify(past <= 0,
                       "a dropdown in the scene cannot leave the window, yet it "
                       + "reached " + Math.round(past) + "px past the edge")
            }

            popup.close()
        }
    }
}
