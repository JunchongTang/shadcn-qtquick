import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// Official empty-input-group: input group inside EmptyContent (search box + leading icon + shortcut).
Empty {
    EmptyHeader {
        EmptyTitle { text: qsTr("404 - Not Found") }
        EmptyDescription {
            text: qsTr("The page you're looking for doesn't exist. Try searching for what you need below.")
        }
    }

    EmptyContent {
        InputGroup {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 260    // sm:w-3/4 approximation

            InputGroupInput { placeholderText: qsTr("Try searching for pages...") }
            InputGroupAddon {
                LucideIcon { name: "search"; size: 14; color: Theme.mutedForeground }
            }
            InputGroupAddon {
                align: InputGroupAddon.InlineEnd
                Kbd { text: "/" }
            }
        }

        EmptyDescription { text: qsTr("Need help? Contact support") }
    }
}
