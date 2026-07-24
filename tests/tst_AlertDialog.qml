import QtQuick
import QtTest
import Shadcn

// AlertDialog unit tests: default property values, the Size enum, action/cancel
// signal wiring, and opened-state geometry (surface width, header text wiring,
// centered vs left-aligned title). Being a modal popup, only what is assertable
// without real user interaction is covered: buttons are exercised by emitting
// their clicked() signal directly. Deterministic under the offscreen platform.
Item {
    id: root
    width: 500
    height: 600

    // Default size, no media.
    AlertDialog {
        id: basic
        title: "Are you absolutely sure?"
        description: "This action cannot be undone."
        cancelText: "Cancel"
        actionText: "Continue"
    }

    // Small size with a media badge (centered layout).
    AlertDialog {
        id: small
        size: AlertDialog.Sm
        mediaIconName: "trash-2"
        mediaDestructive: true
        title: "Delete chat?"
        description: "This will permanently delete this chat conversation."
        cancelText: "Cancel"
        actionText: "Delete"
        actionVariant: Button.Destructive
    }

    SignalSpy { id: acceptedSpy; target: basic; signalName: "accepted" }

    TestCase {
        id: testCase
        name: "AlertDialog"
        when: windowShown

        // Recursive lookup by objectName.
        function findByName(item, name) {
            if (!item)
                return null
            for (var i = 0; i < item.children.length; i++) {
                var c = item.children[i]
                if (c.objectName === name)
                    return c
                var f = findByName(c, name)
                if (f)
                    return f
            }
            return null
        }

        // Recursive lookup of a visible Text whose text matches the given string.
        // Hidden subtrees are skipped so only the active header branch matches
        // (both the media and stacked headers carry a title Text).
        function findText(item, str) {
            if (!item)
                return null
            for (var i = 0; i < item.children.length; i++) {
                var c = item.children[i]
                if (c.hasOwnProperty("visible") && c.visible === false)
                    continue
                if (c.hasOwnProperty("text") && c.text === str && c.hasOwnProperty("wrapMode"))
                    return c
                var f = findText(c, str)
                if (f)
                    return f
            }
            return null
        }

        function init() {
            acceptedSpy.clear()
            basic.close()
            small.close()
        }

        function cleanup() {
            basic.close()
            small.close()
        }

        // ---- Defaults ----
        function test_defaults() {
            compare(basic.size, AlertDialog.Default)
            compare(basic.mediaIconName, "")
            compare(basic.mediaDestructive, false)
            compare(basic.description, "This action cannot be undone.")
            compare(basic.actionVariant, Button.Default)
            verify(basic.modal)
            // Base bars are suppressed; header/footer live in contentItem.
            compare(basic.header, null)
            compare(basic.footer, null)
        }

        // ---- Size enum + derived flags ----
        function test_size_enum() {
            compare(AlertDialog.Default, 0)   // must stay 0 to match Button.Default (#028)
            compare(AlertDialog.Sm, 1)
            // Default: left-aligned, no media.
            compare(basic._sm, false)
            compare(basic._centered, false)
            compare(basic._hasMedia, false)
            // Small with media: centered.
            compare(small._sm, true)
            compare(small._centered, true)
            compare(small._hasMedia, true)
        }

        // ---- Action button emits accepted() and closes ----
        function test_action_emits_accepted() {
            basic.open()
            tryVerify(function() { return basic.visible })
            var action = findByName(basic.contentItem, "alertDialogAction")
            verify(action !== null)
            compare(action.text, "Continue")
            action.clicked()
            compare(acceptedSpy.count, 1)
            tryVerify(function() { return !basic.visible })
        }

        // ---- Cancel button closes without emitting accepted() ----
        function test_cancel_closes_only() {
            basic.open()
            tryVerify(function() { return basic.visible })
            var cancel = findByName(basic.contentItem, "alertDialogCancel")
            verify(cancel !== null)
            compare(cancel.text, "Cancel")
            cancel.clicked()
            compare(acceptedSpy.count, 0)
            tryVerify(function() { return !basic.visible })
        }

        // ---- Default open geometry: surface width and header wiring ----
        function test_open_geometry_default() {
            basic.open()
            tryVerify(function() { return basic.visible && basic.contentItem.width > 0 })
            // implicitWidth 384 minus p-4 on both sides (16*2) = 352.
            fuzzyCompare(basic.contentItem.width, 384 - 2 * 16, 2)
            // Title and description are wired and left-aligned.
            var title = findText(basic.contentItem, basic.title)
            var desc = findText(basic.contentItem, basic.description)
            verify(title !== null)
            verify(desc !== null)
            compare(title.horizontalAlignment, Text.AlignLeft)
            // Background surface uses the rounded-xl radius.
            fuzzyCompare(basic.background.radius, Theme.radiusXl, 0.5)
        }

        // ---- Small open geometry: narrower, centered title, media present ----
        function test_open_geometry_small() {
            small.open()
            tryVerify(function() { return small.visible && small.contentItem.width > 0 })
            // implicitWidth 256 minus p-4 both sides = 224.
            fuzzyCompare(small.contentItem.width, 256 - 2 * 16, 2)
            var title = findText(small.contentItem, small.title)
            verify(title !== null)
            compare(title.horizontalAlignment, Text.AlignHCenter)
            // The media icon is wired to the requested Lucide name.
            verify(small._hasMedia)
        }
    }
}
