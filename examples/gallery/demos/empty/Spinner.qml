import QtQuick
import QtQuick.Layouts
import Shadcn

// Official spinner-empty: Spinner inside the icon rounded slot (processing state).
Empty {
    EmptyHeader {
        EmptyMedia {
            variant: EmptyMedia.Icon
            Spinner { size: 16 }    // svg size-4 inside the rounded slot
        }
        EmptyTitle { text: qsTr("Processing your request") }
        EmptyDescription {
            text: qsTr("Please wait while we process your request. Do not refresh the page.")
        }
    }

    EmptyContent {
        Button {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Cancel")
            variant: Button.Outline
            size: Button.Sm
        }
    }
}
