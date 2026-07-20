import QtQuick
import Shadcn

// 带分隔符:2+2+2 三组,组间自动插入 InputOtpSeparator(对标 input-otp-separator)。
InputOtp {
    length: 6
    groups: [2, 2, 2]
}
