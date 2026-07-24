import QtQuick
import QtTest
import Shadcn

// Alert unit tests. Alert is itself a Rectangle, so its own color / border /
// radius ARE the background; appearance is asserted by reading those after
// render. Deterministic under the offscreen platform (no animations here).
Item {
    id: root
    width: 480
    height: 480

    Alert {
        id: aDefault
        width: 400
        iconName: "circle-check"
        title: "Account updated successfully"
        description: "Your profile information has been saved."
    }

    Alert {
        id: aDestructive
        width: 400
        variant: Alert.Destructive
        iconName: "circle-alert"
        title: "Payment failed"
        description: "Your payment could not be processed."
    }

    // Custom palette (amber "colors" example): variant untouched, roles overridden.
    Alert {
        id: aColors
        width: 400
        surface: "#fffbeb"
        stroke: "#fde68a"
        titleColor: "#78350f"
        descColor: "#78350f"
        iconName: "triangle-alert"
        title: "Your subscription will expire in 3 days."
        description: "Renew now to avoid service interruption."
    }

    // Action slot: a child item becomes the trailing action.
    Alert {
        id: aAction
        width: 400
        title: "Dark mode is now available"
        description: "Enable it under your profile settings to get started."
        Rectangle { id: actionChild; width: 60; height: 24; color: "#123456" }
    }

    TestCase {
        name: "Alert"
        when: windowShown

        function test_defaults() {
            let a = Qt.createQmlObject("import Shadcn; Alert {}", root)
            compare(a.variant, Alert.Default)
            compare(a.title, "")
            compare(a.description, "")
            compare(a.iconName, "")
            compare(a.implicitWidth, 400)
            compare(a.radius, Theme.radiusLg)
            compare(a.border.width, 1)
            a.destroy()
        }

        // Enum member values (Default must be 0).
        function test_variant_enum() {
            compare(Alert.Default, 0)
            compare(Alert.Destructive, 1)
        }

        // Default variant: card surface, border token, card-foreground title,
        // muted-foreground description.
        function test_default_colors() {
            compare(aDefault.color, Theme.card)
            compare(aDefault.border.color, Theme.border)
            compare(aDefault.titleColor, Theme.cardForeground)
            compare(aDefault.descColor, Theme.mutedForeground)
        }

        // Destructive variant: title = destructive, description = destructive/90,
        // surface stays the card token.
        function test_destructive_colors() {
            compare(aDestructive.color, Theme.card)
            compare(aDestructive.titleColor, Theme.destructive)
            compare(aDestructive.descColor, Theme.alpha(Theme.destructive, 0.9))
        }

        // Overriding the color roles applies a custom palette without changing variant.
        function test_color_override() {
            compare(aColors.variant, Alert.Default)
            compare(aColors.color, Qt.color("#fffbeb"))
            compare(aColors.border.color, Qt.color("#fde68a"))
            compare(aColors.titleColor, Qt.color("#78350f"))
        }

        // Content-driven height: padded height exceeds the two 6px paddings.
        function test_content_geometry() {
            verify(aDefault.implicitHeight > Theme.space1_5 * 2)
            // Height tracks implicitHeight when no explicit height is set.
            compare(aDefault.height, aDefault.implicitHeight)
        }

        // Trailing action child is parented into the alert and rendered.
        function test_action_slot() {
            compare(aAction.action.length, 1)
            verify(actionChild.visible)
            verify(actionChild.width > 0)
        }
    }
}
