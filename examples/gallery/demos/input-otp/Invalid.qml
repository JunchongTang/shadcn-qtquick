import QtQuick
import Shadcn

// 错误态:invalid=true → 边框/环转破坏色(对标 input-otp-invalid)。
InputOtp {
    length: 6
    groups: [2, 2, 2]
    value: "000000"
    invalid: true
}
