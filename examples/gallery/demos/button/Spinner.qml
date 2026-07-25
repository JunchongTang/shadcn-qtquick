import QtQuick
import QtQuick.Layouts
import Shadcn

// loading:按钮内显示旋转 Spinner 并禁用交互(dim)。
RowLayout {
    spacing: 8
    Button { variant: Button.Outline; text: qsTr("Generating"); loading: true }
    Button { variant: Button.Secondary; text: qsTr("Downloading"); loading: true }
}
