import QtQuick

PageScaffold {
    description: qsTr("Accessible one-time password component. Click a field and type; use Backspace to delete.")

    ExampleCard {
        title: qsTr("Input OTP")
        source: "qrc:/demos/input-otp/Demo.qml"
    }
    ExampleCard {
        title: qsTr("Pattern")
        description: qsTr("Use the pattern property to restrict input. Here only digits are accepted.")
        source: "qrc:/demos/input-otp/Pattern.qml"
    }
    ExampleCard {
        title: qsTr("Separator")
        description: qsTr("Split the slots into groups with a separator in between.")
        source: "qrc:/demos/input-otp/Separator.qml"
    }
    ExampleCard {
        title: qsTr("Disabled")
        description: qsTr("Use the disabled state to prevent interaction.")
        source: "qrc:/demos/input-otp/Disabled.qml"
    }
    ExampleCard {
        title: qsTr("Controlled")
        description: qsTr("Read the value property to react to input.")
        source: "qrc:/demos/input-otp/Controlled.qml"
    }
    ExampleCard {
        title: qsTr("Invalid")
        description: qsTr("Use the invalid state to indicate a validation error.")
        source: "qrc:/demos/input-otp/Invalid.qml"
    }
    ExampleCard {
        title: qsTr("Four Digits")
        description: qsTr("A common pattern for PIN codes, restricted to digits.")
        source: "qrc:/demos/input-otp/FourDigits.qml"
    }
    ExampleCard {
        title: qsTr("Alphanumeric")
        description: qsTr("Accept both letters and numbers.")
        source: "qrc:/demos/input-otp/Alphanumeric.qml"
    }
}
