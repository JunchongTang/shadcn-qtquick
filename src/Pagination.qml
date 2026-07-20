import QtQuick
import QtQuick.Layouts
import LucideIcons

// shadcn Pagination(base-mira)—— 数据驱动版:由 count(总页) / page(当前页,1 基)
// 生成「上一页 + 页码(含省略号) + 下一页」。当前页 outline 高亮,其余 ghost。
// 对齐 .cn-pagination-*:content gap-0.5;ellipsis size-7 + svg size-3.5;
// previous pl-2! / next pr-2!。点击页码/翻页按钮会更新 page 并发出 pageRequested。
RowLayout {
    id: control

    property int count: 1                 // 总页数
    property int page: 1                  // 当前页(1 基)
    property int siblingCount: 1          // 当前页两侧各显示的页码数
    property bool showPrevNext: true      // 是否显示「上一页 / 下一页」
    property bool showPages: true         // 是否显示页码(false = 仅前后按钮)
    property string previousText: qsTr("Previous")
    property string nextText: qsTr("Next")

    signal pageRequested(int page)

    spacing: Theme.space0_5               // .cn-pagination-content: gap-0.5 = 2

    function _goto(p) {
        var np = Math.min(Math.max(1, p), Math.max(1, count))
        if (np !== page)
            page = np
        pageRequested(np)
    }

    // 页码序列生成:返回数字与省略号标记("ellipsis")混合的数组。
    // 与 react-hooks 常见分页算法一致:首页/末页常驻,当前页 ± siblingCount,
    // 两端有缺口时插入省略号。
    function _pages(total, current, sib) {
        total = Math.max(1, total)
        current = Math.min(Math.max(1, current), total)

        // 无需折叠:首 + 末 + 当前 + 2*sib + 两个省略号占位。
        var totalNumbers = sib * 2 + 5
        if (totalNumbers >= total)
            return _range(1, total)

        var leftSibling = Math.max(current - sib, 1)
        var rightSibling = Math.min(current + sib, total)
        var showLeftDots = leftSibling > 2
        var showRightDots = rightSibling < total - 1
        var edgeCount = 3 + 2 * sib

        if (!showLeftDots && showRightDots)
            return _range(1, edgeCount).concat(["ellipsis", total])
        if (showLeftDots && !showRightDots)
            return [1, "ellipsis"].concat(_range(total - edgeCount + 1, total))
        return [1, "ellipsis"].concat(_range(leftSibling, rightSibling))
                              .concat(["ellipsis", total])
    }

    function _range(start, end) {
        var r = []
        for (var i = start; i <= end; i++)
            r.push(i)
        return r
    }

    readonly property var _items: _pages(count, page, siblingCount)

    // ==== 上一页 ====
    Button {
        visible: control.showPrevNext
        variant: Button.Ghost
        size: Button.Default
        iconName: "chevron-left"
        text: control.previousText
        enabled: control.page > 1
        leftPadding: Theme.space2           // .cn-pagination-previous: pl-2!
        onClicked: control._goto(control.page - 1)
    }

    // ==== 页码(含省略号)====
    Repeater {
        model: control.showPages ? control._items : []
        delegate: Item {
            required property var modelData
            readonly property bool _isEllipsis: modelData === "ellipsis"

            implicitWidth: 28               // size-7
            implicitHeight: 28

            // 省略号:size-7 容器 + svg size-3.5。
            LucideIcon {
                anchors.centerIn: parent
                visible: parent._isEllipsis
                name: "ellipsis"
                size: 14                    // svg size-3.5
                color: Theme.foreground
            }

            // 页码按钮:当前页 outline,其余 ghost;方形 size-7。
            Button {
                anchors.fill: parent
                visible: !parent._isEllipsis
                variant: (modelData === control.page) ? Button.Outline : Button.Ghost
                size: Button.Default
                text: parent._isEllipsis ? "" : String(modelData)
                leftPadding: 0
                rightPadding: 0
                onClicked: control._goto(modelData)
            }
        }
    }

    // ==== 下一页 ====
    Button {
        visible: control.showPrevNext
        variant: Button.Ghost
        size: Button.Default
        trailingIconName: "chevron-right"
        text: control.nextText
        enabled: control.page < control.count
        rightPadding: Theme.space2          // .cn-pagination-next: pr-2!
        onClicked: control._goto(control.page + 1)
    }
}
