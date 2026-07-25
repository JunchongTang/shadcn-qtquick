import QtQuick

PageScaffold {
    description: qsTr("A versatile component for displaying content with media, title, description, and actions.")

    ExampleCard {
        title: qsTr("Item")
        source: "qrc:/demos/item/Demo.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: qsTr("Variant")
        description: qsTr("Use the variant prop to change the visual style: default, outline, or muted.")
        source: "qrc:/demos/item/Variants.qml"
        previewMinHeight: 300
    }
    ExampleCard {
        title: qsTr("Size")
        description: qsTr("Use the size prop to change the size of the item. Available sizes are default, sm, and xs.")
        source: "qrc:/demos/item/Sizes.qml"
        previewMinHeight: 300
    }
    ExampleCard {
        title: qsTr("Icon")
        description: qsTr("Use ItemMedia with variant icon to display an icon.")
        source: "qrc:/demos/item/Icon.qml"
    }
    ExampleCard {
        title: qsTr("Avatar")
        description: qsTr("Use ItemMedia to display an avatar, or a stacked avatar group.")
        source: "qrc:/demos/item/Avatar.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: qsTr("Image")
        description: qsTr("Use ItemMedia with variant image to display an image.")
        source: "qrc:/demos/item/Image.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: qsTr("Group")
        description: qsTr("Use ItemGroup to group related items together.")
        source: "qrc:/demos/item/Group.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: qsTr("Header")
        description: qsTr("Use ItemHeader to add a header above the item content.")
        source: "qrc:/demos/item/Header.qml"
        previewMinHeight: 300
    }
    ExampleCard {
        title: qsTr("Footer")
        description: qsTr("Use ItemHeader and ItemFooter to frame the content with full-width rows.")
        source: "qrc:/demos/item/Footer.qml"
    }
    ExampleCard {
        title: qsTr("Link")
        description: qsTr("Use asLink to make the whole item clickable. Hover and focus states apply to the item.")
        source: "qrc:/demos/item/Link.qml"
        previewMinHeight: 220
    }
    ExampleCard {
        title: qsTr("Separator")
        description: qsTr("Use ItemSeparator between items in a group.")
        source: "qrc:/demos/item/Separator.qml"
        previewMinHeight: 240
    }
}
