import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8
    Avatar { size: Avatar.Sm; source: "https://github.com/shadcn.png"; fallback: "CN" }
    Avatar { source: "https://github.com/shadcn.png"; fallback: "CN" }
    Avatar { size: Avatar.Lg; source: "https://github.com/shadcn.png"; fallback: "CN" }
}
