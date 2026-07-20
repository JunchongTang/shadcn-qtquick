import QtQuick
import Shadcn

// 字母数字:REGEXP_ONLY_DIGITS_AND_CHARS → 逐字符正则,3+3 分组(对标 input-otp-alphanumeric)。
InputOtp {
    length: 6
    groups: [3, 3]
    pattern: "[a-zA-Z0-9]"
}
