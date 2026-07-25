import QtQuick
import QtQuick.Layouts
import Shadcn

// 受控:读取 value 实时回显(对标 input-otp-controlled)。
ColumnLayout {
    spacing: 8
    InputOtp {
        id: otp
        length: 6
    }
    Text {
        Layout.alignment: Qt.AlignHCenter
        text: otp.value === "" ? qsTr("Enter your one-time password.")
                               : qsTr("You entered: ") + otp.value
        color: Theme.foreground
        font.pixelSize: Theme.textSm
    }
}
