import QtQuick
import Shadcn

// Alphanumeric: REGEXP_ONLY_DIGITS_AND_CHARS → per-char regex, 3+3 groups (mirrors input-otp-alphanumeric).
InputOtp {
    length: 6
    groups: [3, 3]
    pattern: "[a-zA-Z0-9]"
}
