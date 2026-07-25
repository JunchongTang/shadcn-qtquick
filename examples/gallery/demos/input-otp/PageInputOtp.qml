import QtQuick

PageScaffold {
    description: "Accessible one-time password component. Click a field and type; use Backspace to delete."

    ExampleCard {
        title: "Input OTP"
        source: "qrc:/demos/input-otp/Demo.qml"
    }
    ExampleCard {
        title: "Pattern"
        description: "Use the pattern property to restrict input. Here only digits are accepted."
        source: "qrc:/demos/input-otp/Pattern.qml"
    }
    ExampleCard {
        title: "Separator"
        description: "Split the slots into groups with a separator in between."
        source: "qrc:/demos/input-otp/Separator.qml"
    }
    ExampleCard {
        title: "Disabled"
        description: "Use the disabled state to prevent interaction."
        source: "qrc:/demos/input-otp/Disabled.qml"
    }
    ExampleCard {
        title: "Controlled"
        description: "Read the value property to react to input."
        source: "qrc:/demos/input-otp/Controlled.qml"
    }
    ExampleCard {
        title: "Invalid"
        description: "Use the invalid state to indicate a validation error."
        source: "qrc:/demos/input-otp/Invalid.qml"
    }
    ExampleCard {
        title: "Four Digits"
        description: "A common pattern for PIN codes, restricted to digits."
        source: "qrc:/demos/input-otp/FourDigits.qml"
    }
    ExampleCard {
        title: "Alphanumeric"
        description: "Accept both letters and numbers."
        source: "qrc:/demos/input-otp/Alphanumeric.qml"
    }
}
