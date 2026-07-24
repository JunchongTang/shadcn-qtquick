import QtQuick
import QtQuick.Layouts
import QtTest
import Shadcn

// Dialog unit tests: default property values, title/description wiring in the
// header, the footerContent slot populating the muted footer bar, open()/close()
// visibility, and the rounded-xl background radius. Dialog is a Popup-derived
// modal, so only what is assertable without real pointer input is covered; the
// dialog is opened so header/footer geometry can be read. Deterministic under
// the offscreen platform.
Item {
    id: root
    width: 640
    height: 640

    // Fully-wired dialog: title + description in the header, body content, and a
    // trailing footer RowLayout.
    Dialog {
        id: dlg
        title: "Are you sure?"
        description: "This action cannot be undone."

        Text {
            objectName: "bodyText"
            text: "Body content goes here."
        }

        footerContent: RowLayout {
            objectName: "footerRow"
            Item { Layout.fillWidth: true }
            Button { objectName: "cancelBtn"; text: "Cancel" }
            Button { objectName: "confirmBtn"; text: "Confirm" }
        }
    }

    // Dialog without a footer: the footer bar must collapse (visible false).
    Dialog {
        id: noFooter
        title: "No footer"
        Text { text: "Just a body." }
    }

    TestCase {
        id: testCase
        name: "Dialog"
        when: windowShown

        // Recursive lookup by objectName within an item subtree.
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

        // Recursive lookup of a visible Text whose text matches, skipping hidden
        // subtrees so only the active header branch matches.
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

        // Recursive lookup of an item carrying iconName === name.
        function findIcon(item, name) {
            if (!item)
                return null
            for (var i = 0; i < item.children.length; i++) {
                var c = item.children[i]
                if (c.hasOwnProperty("iconName") && c.iconName === name)
                    return c
                var f = findIcon(c, name)
                if (f)
                    return f
            }
            return null
        }

        function init() {
            dlg.close()
            noFooter.close()
        }

        function cleanup() {
            dlg.close()
            noFooter.close()
        }

        // ---- Defaults ----
        function test_defaults() {
            compare(dlg.showCloseButton, true)
            verify(dlg.modal)
            compare(dlg.implicitWidth, 360)
            compare(noFooter.description, "")
            // Body padding is p-4 (space4).
            compare(dlg.padding, Theme.space4)
        }

        // ---- Background surface uses the rounded-xl radius ----
        function test_background_radius() {
            verify(dlg.background !== null)
            fuzzyCompare(dlg.background.radius, Theme.radiusXl, 0.5)
        }

        // ---- open() shows, close() hides ----
        // Opening/closing runs the enter/exit transitions, so visibility only
        // settles asynchronously; poll rather than reading it synchronously.
        function test_open_close() {
            // init() just called close(); wait for any exit transition to finish.
            tryCompare(dlg, "visible", false)
            dlg.open()
            tryCompare(dlg, "opened", true)
            tryCompare(dlg, "visible", true)
            dlg.close()
            tryCompare(dlg, "opened", false)
            tryCompare(dlg, "visible", false)
        }

        // ---- Title and description are wired into the header ----
        function test_header_wiring() {
            dlg.open()
            tryCompare(dlg, "visible", true)
            var title = findText(dlg.header, dlg.title)
            var desc = findText(dlg.header, dlg.description)
            verify(title !== null)
            verify(desc !== null)
            compare(title.color, Theme.foreground)
            compare(desc.color, Theme.mutedForeground)
            // Close button (the Lucide XIcon) is present when showCloseButton is on.
            var closeBtn = findIcon(dlg.header, "x")
            verify(closeBtn !== null)
        }

        // ---- footerContent populates the footer bar and stretches to full width ----
        function test_footer_slot() {
            dlg.open()
            tryCompare(dlg, "visible", true)
            // Footer bar is visible and has a non-zero height.
            verify(dlg.footer.visible)
            verify(dlg.footer.implicitHeight > 0)
            // The assigned RowLayout lives inside the footer.
            var row = findByName(dlg.footer, "footerRow")
            verify(row !== null)
            // It is stretched to the padded full width (p-4 inset on both sides).
            tryVerify(function() { return row.width > 0 })
            fuzzyCompare(row.width, dlg.footer.width - 2 * Theme.space4, 2)
            // Both footer buttons are wired.
            var cancel = findByName(dlg.footer, "cancelBtn")
            var confirm = findByName(dlg.footer, "confirmBtn")
            verify(cancel !== null)
            verify(confirm !== null)
            compare(cancel.text, "Cancel")
            compare(confirm.text, "Confirm")
        }

        // ---- Without footer content the footer bar collapses ----
        function test_footer_collapses_when_empty() {
            noFooter.open()
            tryCompare(noFooter, "visible", true)
            verify(!noFooter.footer.visible)
            compare(noFooter.footer.implicitHeight, 0)
        }

        // ---- Body content lands in the content item ----
        function test_body_content() {
            dlg.open()
            tryCompare(dlg, "visible", true)
            var body = findByName(dlg.contentItem, "bodyText")
            verify(body !== null)
            compare(body.text, "Body content goes here.")
        }
    }
}
