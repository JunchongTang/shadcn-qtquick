import QtQuick
import Shadcn

// 四位 PIN:maxLength=4 + 仅数字(对标 input-otp-four-digits)。
InputOtp {
    length: 4
    pattern: "[0-9]"
}
