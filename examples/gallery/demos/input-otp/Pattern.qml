import QtQuick
import QtQuick.Layouts
import Shadcn

// Pattern: digits only (REGEXP_ONLY_DIGITS → per-char regex "[0-9]"), with a Label (mirrors input-otp-pattern).
ColumnLayout {
    spacing: 6
    Label { text: qsTr("Digits Only") }
    InputOtp {
        length: 6
        pattern: "[0-9]"
    }
}
