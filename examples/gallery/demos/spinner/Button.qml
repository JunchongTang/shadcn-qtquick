import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 spinner-button:按钮内 loading 状态 —— Button.loading 前置显示 Spinner 并禁用交互。
ColumnLayout {
    spacing: Theme.space4                  // gap-4

    Button {
        Layout.alignment: Qt.AlignHCenter
        text: "Loading..."; size: Button.Sm; loading: true
    }
    Button {
        Layout.alignment: Qt.AlignHCenter
        text: "Please wait"; size: Button.Sm; variant: Button.Outline; loading: true
    }
    Button {
        Layout.alignment: Qt.AlignHCenter
        text: "Processing"; size: Button.Sm; variant: Button.Secondary; loading: true
    }
}
