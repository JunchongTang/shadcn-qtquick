import QtQuick
import QtQuick.Layouts
import Shadcn

// loading:按钮内显示旋转 Spinner 并禁用交互(dim)。
RowLayout {
    spacing: 8
    Button { variant: Button.Outline; text: "Generating"; loading: true }
    Button { variant: Button.Secondary; text: "Downloading"; loading: true }
}
