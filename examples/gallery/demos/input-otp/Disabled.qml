import QtQuick
import Shadcn

// 禁用态:enabled=false → 整件 opacity-50 且不接受输入(对标 input-otp-disabled)。
InputOtp {
    length: 6
    groups: [3, 3]
    value: "123456"
    enabled: false
}
