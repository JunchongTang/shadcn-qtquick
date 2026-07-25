import QtQuick
import QtQuick.Layouts
import Shadcn

// model 驱动的动态面包屑:面包屑本身是纯展示,状态在外部的 path 数组里。
// 改 path(重新赋值)→ Repeater 自动重建。演示三种动态切换:
//   · 点某一级链接 → 截断到那一级(常见的"点面包屑回上层")
//   · Navigate deeper → 向 path 追加新一层
//   · Reset → 还原初始路径
Column {
    id: root
    spacing: Theme.space4

    // 当前路径:每项一层,最后一项 = 当前页(无链接)。
    property var path: [
        { label: qsTr("Home") },
        { label: qsTr("Components") },
        { label: qsTr("Breadcrumb") }
    ]
    // 追加时轮换取用的下一级名字。
    readonly property var pool: ["Settings", "Profile", "Billing", "Team", "Details"]

    // ==== 面包屑:由 path 生成 ====
    Breadcrumb {
        Repeater {
            id: rep
            model: root.path
            delegate: RowLayout {
                id: crumb
                required property int index
                required property var modelData
                readonly property bool isLast: index === rep.count - 1
                spacing: Theme.space1_5

                // 首项前不放分隔符
                BreadcrumbSeparator { visible: crumb.index > 0 }

                BreadcrumbItem {
                    // 非末项 = 可点链接;点它截断路径到这一级
                    BreadcrumbLink {
                        visible: !crumb.isLast
                        text: crumb.modelData.label
                        onClicked: root.path = root.path.slice(0, crumb.index + 1)
                    }
                    // 末项 = 当前页
                    BreadcrumbPage {
                        visible: crumb.isLast
                        text: crumb.modelData.label
                    }
                }
            }
        }
    }

    // ==== 动态切换控制 ====
    Row {
        spacing: Theme.space2

        Button {
            text: qsTr("Navigate deeper")
            variant: Button.Outline
            size: Button.Sm
            enabled: root.path.length < root.pool.length + 3
            // 取一个尚未出现在 path 里的名字,追加为新的当前页
            onClicked: {
                var next = root.pool[(root.path.length - 3) % root.pool.length]
                root.path = root.path.concat([{ label: next }])
            }
        }
        Button {
            text: qsTr("Reset")
            variant: Button.Ghost
            size: Button.Sm
            onClicked: root.path = [
                { label: qsTr("Home") },
                { label: qsTr("Components") },
                { label: qsTr("Breadcrumb") }
            ]
        }
    }
}
