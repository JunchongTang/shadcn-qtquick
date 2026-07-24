import QtQuick
import QtTest
import Shadcn

// Marker unit tests: defaults, enum stability, resolved text color per state,
// icon-slot detection and rendered geometry (min height, border padding, the
// separator's flex-fill dividers, and the stacked layout being taller than the
// equivalent row). Deterministic under the offscreen platform: no hover fires,
// so interactive markers resolve to the muted-foreground (non-hovered) color.
// Theme.dark defaults to false, so light-mode tokens apply.
Item {
    id: root
    width: 400
    height: 400

    // Fixed width so wrapping/geometry is identical across compared instances.
    component M: Marker {
        width: 200
        height: implicitHeight
    }

    M { id: mDefault; text: "Hello world" }
    M { id: mBorder; text: "Hello world"; variant: Marker.Border }
    M { id: mSeparator; text: "Today"; variant: Marker.Separator }
    M { id: mInteractive; text: "View the pull request"; interactive: true }
    M { id: mIcon; text: "Switched branch"; iconName: "git-branch" }
    M { id: mSpinner; text: "Compacting"; spinner: true }
    M { id: mRow; text: "Syncing"; iconName: "check" }
    M { id: mStacked; text: "Syncing"; iconName: "check"; stacked: true }
    M { id: mEmpty }

    TestCase {
        name: "Marker"
        when: windowShown

        function test_defaults() {
            compare(mDefault.variant, Marker.Default)
            compare(mDefault.text, "Hello world")
            compare(mDefault.iconName, "")
            compare(mDefault.spinner, false)
            compare(mDefault.shimmer, false)
            compare(mDefault.interactive, false)
            compare(mDefault.underline, false)
            compare(mDefault.stacked, false)
            compare(mDefault._iconSize, 14)   // svg size-3.5
        }

        // Enum values/names are stable API.
        function test_enum_values() {
            compare(Marker.Default, 0)
            compare(Marker.Separator, 1)
            compare(Marker.Border, 2)
        }

        // Default and interactive-not-hovered both resolve to muted-foreground;
        // offscreen never fires hover, so the interactive branch stays muted.
        function test_text_color() {
            compare(mDefault._textColor, Theme.mutedForeground)
            compare(mInteractive._textColor, Theme.mutedForeground)
        }

        // Icon-slot detection: a Lucide name or the spinner flag counts.
        function test_has_icon() {
            compare(mDefault._hasIcon, false)
            compare(mIcon._hasIcon, true)
            compare(mSpinner._hasIcon, true)
        }

        // min-h-4 (16) even for an empty marker.
        function test_min_height() {
            verify(mEmpty.implicitHeight >= 16)
        }

        // border variant adds pb-2 (8) + border-b (1) = 9 below an identical row.
        function test_border_padding() {
            verify(mDefault.implicitHeight > 16)   // 12px relaxed text is taller than 16
            compare(mBorder.implicitHeight, mDefault.implicitHeight + Theme.space2 + 1)
        }

        // Separator lays out two flex-1 dividers, so the row fills its width and
        // still honors the 16px minimum.
        function test_separator_geometry() {
            compare(mSeparator.width, 200)
            verify(mSeparator.implicitHeight >= 16)
        }

        // Stacked (flex-col) icon-over-content is taller than the equivalent row.
        function test_stacked_taller_than_row() {
            verify(mStacked.implicitHeight > mRow.implicitHeight)
        }
    }
}
