import QtQuick
import QtQuick.Layouts
import Shadcn

// Pattern:仅数字(REGEXP_ONLY_DIGITS → 逐字符正则 "[0-9]"),配 Label(对标 input-otp-pattern)。
ColumnLayout {
    spacing: 6
    Label { text: qsTr("Digits Only") }
    InputOtp {
        length: 6
        pattern: "[0-9]"
    }
}
