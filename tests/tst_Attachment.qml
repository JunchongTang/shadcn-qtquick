import QtQuick
import QtTest
import Shadcn

// Attachment family unit tests: enum defaults, size scale (media box, radius,
// padding, gap), orientation-driven card width, the shimmer/error derived flags,
// and metadata colors. Geometry and colors are asserted after render; layout that
// depends on child routing (_route runs in Component.onCompleted) uses tryCompare.
Item {
    id: root
    width: 480
    height: 480

    // Horizontal card (default size/state).
    Attachment {
        id: aH
        AttachmentMedia { iconName: "file" }
        AttachmentContent {
            AttachmentName { id: hName; text: "report.pdf" }
            AttachmentSize { text: "PDF - 2.4 MB" }
        }
    }

    // Vertical card with content -> w-30 (120).
    Attachment {
        id: aV
        orientation: Attachment.Vertical
        AttachmentMedia { variant: AttachmentMedia.Image }
        AttachmentContent { AttachmentName { text: "img.png" } }
    }

    // Vertical card without content -> w-24 (96).
    Attachment {
        id: aVbare
        orientation: Attachment.Vertical
        AttachmentMedia { iconName: "file" }
    }

    // Extra-small card for radius/gap checks.
    Attachment {
        id: aXs
        size: Attachment.Xs
        AttachmentContent { AttachmentName { text: "a" } }
    }

    // Standalone media at each size.
    AttachmentMedia { id: mDefault; iconName: "file" }
    AttachmentMedia { id: mSm; hostSize: Attachment.Sm; iconName: "file" }
    AttachmentMedia { id: mXs; hostSize: Attachment.Xs; iconName: "file" }
    AttachmentMedia { id: mImg; variant: AttachmentMedia.Image; hostState: Attachment.Uploading }

    // Standalone actions rows.
    AttachmentActions { id: actH }
    AttachmentActions { id: actV; hostOrientation: Attachment.Vertical }

    // Standalone metadata.
    AttachmentName { id: nm; text: "x" }
    AttachmentName { id: nmShimmer; text: "x"; hostState: Attachment.Uploading }
    AttachmentSize { id: szDefault; text: "meta" }
    AttachmentSize { id: szErr; text: "failed"; hostState: Attachment.Error }

    // Group of two cards.
    AttachmentGroup {
        id: grp
        Attachment { AttachmentMedia { iconName: "file" } }
        Attachment { AttachmentMedia { iconName: "file" } }
    }

    TestCase {
        name: "Attachment"
        when: windowShown

        function test_defaults() {
            compare(aH.uploadState, Attachment.Done)
            compare(aH.size, Attachment.Default)
            compare(aH.orientation, Attachment.Horizontal)
            compare(aH._horizontal, true)
            compare(mDefault.variant, AttachmentMedia.Icon)
        }

        // Radius: default/sm -> radiusLg, xs -> radiusMd.
        function test_radius() {
            compare(aH._radius, Theme.radiusLg)
            compare(aXs._radius, Theme.radiusMd)
        }

        // Padding/gap scale (default: px-2 gap-2; xs: px-1.5 gap-1.5).
        function test_padding_gap() {
            compare(aH._padH, Theme.space2)
            compare(aH._padV, Theme.space1_5)
            compare(aH._gap, Theme.space2)
            compare(aXs._padH, Theme.space1_5)
            compare(aXs._gap, Theme.space1_5)
        }

        // Media square edge: default 40 / sm 32 / xs 28.
        function test_media_box() {
            compare(mDefault._box, 40)
            compare(mSm._box, 32)
            compare(mXs._box, 28)
            compare(mDefault.implicitWidth, 40)
            compare(mDefault.implicitHeight, 40)
        }

        // Icon svg size: default/sm 16, xs 14.
        function test_media_icon_size() {
            compare(mDefault._iconSize, 16)
            compare(mSm._iconSize, 16)
            compare(mXs._iconSize, 14)
        }

        // Image variant dims (opacity-60) while not idle/done.
        function test_media_image_dim() {
            compare(mImg._isImage, true)
            compare(mImg._dim, true)
            mImg.hostState = Attachment.Done
            compare(mImg._dim, false)
            mImg.hostState = Attachment.Uploading
        }

        // Horizontal cards honor min-w-40 (160).
        function test_horizontal_min_width() {
            tryVerify(function() { return aH.implicitWidth >= 160 })
        }

        // Vertical width: 120 with content, 96 without (set during _route).
        function test_vertical_width() {
            tryCompare(aV, "implicitWidth", 120)
            tryCompare(aVbare, "implicitWidth", 96)
        }

        // Actions gap: horizontal 0, vertical space1.
        function test_actions_spacing() {
            compare(actH.spacing, 0)
            compare(actV.spacing, Theme.space1)
        }

        // Name: text-xs, font-medium, foreground; shimmer flag while uploading.
        function test_name_style() {
            compare(nm.font.pixelSize, Theme.textXs)
            compare(nm.font.weight, Font.Medium)
            compare(nm.color, Theme.foreground)
            compare(nm._shimmer, false)
            compare(nmShimmer._shimmer, true)
        }

        // Size color: muted by default, destructive/80 on error.
        function test_size_color() {
            compare(szDefault.color, Theme.mutedForeground)
            compare(szErr.color, Theme.alpha(Theme.destructive, 0.80))
        }

        // Group scrolls horizontally and sizes to its row of cards.
        function test_group() {
            compare(grp.flickableDirection, Flickable.HorizontalFlick)
            tryVerify(function() { return grp.contentWidth > 0 && grp.contentHeight > 0 })
        }
    }
}
