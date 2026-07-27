import QtQuick
import QtQuick.Layouts
import Shadcn

// Official empty-demo: rounded icon + title + description + two action buttons (row) + Learn More link.
Empty {
    EmptyHeader {
        EmptyMedia {
            variant: EmptyMedia.Icon
            iconName: "folder-code"
        }
        EmptyTitle { text: qsTr("No Projects Yet") }
        EmptyDescription {
            text: qsTr("You haven't created any projects yet. Get started by creating your first project.")
        }
    }

    EmptyContent {
        // flex-row justify-center gap-2 -- two buttons centered side by side.
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Theme.space2
            Button { text: qsTr("Create Project") }
            Button { text: qsTr("Import Project"); variant: Button.Outline }
        }
    }

    // Learn More link (direct child of Empty, link style, muted color).
    Button {
        Layout.alignment: Qt.AlignHCenter
        variant: Button.Link
        size: Button.Sm
        text: qsTr("Learn More")
        trailingIconName: "arrow-up-right"
    }
}
