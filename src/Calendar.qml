pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Shadcn

// shadcn Calendar(base-mira)—— 月历,JS Date 自绘 7×6 天网格。
// QtQuick 无内置日历(Qt.labs.calendar 已废弃),故手工计算每月首日星期、
// 补齐上/下月余格。样式对齐 registry/bases/base/ui/calendar.tsx + style-mira .cn-calendar:
//   - .cn-calendar: p-3、--cell-radius=radius-md(8)、--cell-size=spacing(6)(24px)
//   - 选中日 = bg-primary/text-primary-foreground(单选)
//   - 今天    = bg-muted/text-foreground(未选中时)
//   - 非本月  = text-muted-foreground(showOutsideDays 淡显)
//   - 禁用日  = opacity 0.5
//
// 能力(向后兼容,默认行为 = 单月 + 单选 + Label 标题,与历史版本一致):
//   · mode = Single(默认)/ Range —— Range 时先后点击选起止;中间日 bg-muted 直角,
//     起止日 primary 圆角药丸,连接带以 muted 直角横条贯通(对标 mira range_start/middle/end)。
//   · captionLayout = Label(默认)/ Dropdown —— Dropdown 时月/年改用 NativeSelect 切换
//     (对标 .cn-calendar-caption-label / captionLayout="dropdown")。
//   · numberOfMonths = 1(默认)/ >1 —— 并排渲染连续多月,共享一套上/下月导航
//     (对标 numberOfMonths={2},months 容器 gap-4);导航每次前/后移动 1 个月。
//     区间高亮以「绝对日期」比较,故跨月自动连续(每列内含首尾外月补格,视觉衔接)。
Item {
    id: cal

    enum Mode { Single, Range }
    enum CaptionLayout { Label, Dropdown }

    // ==== 公开属性 ====
    // 选择模式:Single(单选,默认)/ Range(区间)。
    property int mode: Calendar.Single
    // 标题布局:Label(纯文字,默认)/ Dropdown(月/年下拉)。
    property int captionLayout: Calendar.Label
    // 并排显示的月数(默认 1;>1 时以 displayMonth 为首月连续排布,共享导航)。
    property int numberOfMonths: 1

    // 当前选中日(Single 模式;未选择时为 undefined)。点击某日即写入。
    property var selectedDate: undefined
    // 区间起止(Range 模式;未选择时为 undefined)。始终保证 rangeStart <= rangeEnd。
    property var rangeStart: undefined
    property var rangeEnd: undefined

    // 当前显示的月份(取其 年/月;日无意义)。多月视图时为首月。
    property date displayMonth: new Date()
    // 是否渲染上/下月补格(对齐 showOutsideDays,默认 true)。
    property bool showOutsideDays: true
    // 单元格边长(mira 令牌 --cell-size 为 spacing(6)=24;此处放大到 32 提升可读性/点击目标,
    // 消费方可设回 24 以严格贴合 mira)。表头/导航随之对齐。
    property real cellSize: 32
    // Dropdown 标题的年份下拉范围(默认 今年-100 .. 今年+10,近似 react-day-picker 默认)。
    property int fromYear: (new Date()).getFullYear() - 100
    property int toYear: (new Date()).getFullYear() + 10

    // 选择某日时发出(Single 模式,参数为 JS Date)。
    signal selected(var date)
    // 区间选择完成时发出(Range 模式选定第二个端点后,参数为起止 JS Date)。
    signal rangeSelected(var start, var end)

    // ==== 内部计算 ====
    readonly property int _year: displayMonth.getFullYear()
    readonly property int _month: displayMonth.getMonth()
    property date _today: new Date()

    readonly property real _pad: Theme.space3           // p-3 = 12
    readonly property real _gridW: cellSize * 7
    readonly property real _monthGap: Theme.space4      // months 容器 gap-4 = 16

    readonly property var _weekdays: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    readonly property var _monthNames: [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]
    readonly property var _monthShort: [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ]
    // Dropdown 年份模型([fromYear..toYear])。
    readonly property var _years: {
        const arr = []
        for (let y = fromYear; y <= toYear; y++)
            arr.push(y)
        return arr
    }

    // 某年某月的 6 行 × 7 列 = 42 个 JS Date(含上/下月补格)。多月视图逐列各自计算。
    function _daysFor(year, month) {
        const first = new Date(year, month, 1)
        const startDow = first.getDay()   // 0 = Sunday
        const arr = []
        for (let i = 0; i < 42; i++)
            arr.push(new Date(year, month, 1 - startDow + i))
        return arr
    }

    function _sameDay(a, b) {
        return a !== undefined && b !== undefined
            && a.getFullYear() === b.getFullYear()
            && a.getMonth() === b.getMonth()
            && a.getDate() === b.getDate()
    }

    // 以 年*10000+月*100+日 编码用于跨月序比较(判定区间中间/端点顺序)。
    function _dayNum(d) {
        return d.getFullYear() * 10000 + d.getMonth() * 100 + d.getDate()
    }

    // 点击某日:Single 写 selectedDate;Range 依次落起点/终点(乱序自动交换)。
    // reframe=true 时(仅单月视图点到外月补格)把 displayMonth 跳到该月;多月视图不重定位。
    function _pick(date, reframe) {
        if (mode === Calendar.Range) {
            if (rangeStart === undefined || rangeEnd !== undefined) {
                // 无起点,或区间已完整 → 从该日重新起一段。
                rangeStart = date
                rangeEnd = undefined
            } else {
                // 已有起点、未定终点 → 落终点(乱序则交换,保证 start<=end)。
                if (_dayNum(date) < _dayNum(rangeStart)) {
                    rangeEnd = rangeStart
                    rangeStart = date
                } else {
                    rangeEnd = date
                }
                rangeSelected(rangeStart, rangeEnd)
            }
        } else {
            selectedDate = date
            selected(date)
        }
        if (reframe)
            displayMonth = new Date(date.getFullYear(), date.getMonth(), 1)
    }

    implicitWidth: _gridW * numberOfMonths + _monthGap * (numberOfMonths - 1) + _pad * 2
    implicitHeight: monthsRow.implicitHeight + _pad * 2

    // ==== 并排月份(共享导航覆于其上)====
    Row {
        id: monthsRow
        x: cal._pad
        y: cal._pad
        spacing: cal._monthGap

        Repeater {
            model: cal.numberOfMonths

            // ---- 单个月列:caption + 周表头 + 6×7 网格 ----
            ColumnLayout {
                id: mcol
                required property int index
                width: cal._gridW
                spacing: Theme.space3

                // 本列月份 = 首月 displayMonth 顺延 index 个月。
                readonly property date _mDate: new Date(cal._year, cal._month + index, 1)
                readonly property int _mYear: _mDate.getFullYear()
                readonly property int _mMonth: _mDate.getMonth()

                // ==== 月标题(纯文字 / 下拉;导航由外层共享,故此处不含 chevron)====
                Item {
                    Layout.fillWidth: true
                    implicitHeight: cal.cellSize

                    // ---- Label 标题(captionLayout = Label,默认)----
                    Text {
                        anchors.centerIn: parent
                        visible: cal.captionLayout === Calendar.Label
                        text: cal._monthNames[mcol._mMonth] + " " + mcol._mYear
                        color: Theme.foreground
                        font.pixelSize: Theme.textSm
                        font.weight: Font.Medium
                    }

                    // ---- Dropdown 标题(captionLayout = Dropdown):月 / 年 NativeSelect ----
                    Row {
                        anchors.centerIn: parent
                        visible: cal.captionLayout === Calendar.Dropdown
                        spacing: Theme.space1_5   // dropdowns gap-1.5

                        NativeSelect {
                            id: monthSelect
                            model: cal._monthShort
                            Component.onCompleted: currentIndex = mcol._mMonth
                            // 选月:令本列显示该月,再回推首月 displayMonth(减去本列偏移)。
                            onActivated: (idx) => {
                                const t = new Date(mcol._mYear, idx, 1)
                                cal.displayMonth = new Date(t.getFullYear(), t.getMonth() - mcol.index, 1)
                            }
                        }
                        NativeSelect {
                            id: yearSelect
                            model: cal._years
                            Component.onCompleted: currentIndex = mcol._mYear - cal.fromYear
                            onActivated: (idx) => {
                                const t = new Date(cal.fromYear + idx, mcol._mMonth, 1)
                                cal.displayMonth = new Date(t.getFullYear(), t.getMonth() - mcol.index, 1)
                            }
                        }

                        // 导航/外月点击改变 displayMonth 时,回写本列两个下拉的当前项。
                        Connections {
                            target: cal
                            function onDisplayMonthChanged() {
                                monthSelect.currentIndex = mcol._mMonth
                                yearSelect.currentIndex = mcol._mYear - cal.fromYear
                            }
                        }
                    }
                }

                // ==== 周表头(Su..Sa)====
                Row {
                    Layout.fillWidth: true
                    spacing: 0
                    Repeater {
                        model: cal._weekdays
                        delegate: Item {
                            required property var modelData
                            width: cal.cellSize
                            height: cal.cellSize * 0.75
                            Text {
                                anchors.centerIn: parent
                                text: parent.modelData
                                color: Theme.mutedForeground
                                font.pixelSize: Theme.textXs
                            }
                        }
                    }
                }

                // ==== 6×7 天网格 ====
                Grid {
                    Layout.fillWidth: true
                    columns: 7
                    rowSpacing: 2
                    columnSpacing: 0

                    Repeater {
                        model: cal._daysFor(mcol._mYear, mcol._mMonth)
                        delegate: Item {
                            id: dayCell
                            required property var modelData   // JS Date
                            width: cal.cellSize
                            height: cal.cellSize

                            // 本格是否属于本列月份(用于淡显外月补格)。
                            readonly property bool inMonth: modelData.getMonth() === mcol._mMonth
                                                         && modelData.getFullYear() === mcol._mYear
                            readonly property bool isToday: cal._sameDay(modelData, cal._today)
                            readonly property bool shown: inMonth || cal.showOutsideDays

                            // 单选高亮(仅 Single 模式)。
                            readonly property bool isSelectedSingle: cal.mode === Calendar.Single
                                                                  && cal._sameDay(modelData, cal.selectedDate)

                            // 区间角色(仅 Range 模式)。_hasSpan:起止均定且跨 ≥2 天,方需连接带。
                            readonly property bool _rangeMode: cal.mode === Calendar.Range
                            readonly property bool _isStart: _rangeMode && cal.rangeStart !== undefined
                                                          && cal._sameDay(modelData, cal.rangeStart)
                            readonly property bool _isEnd: _rangeMode && cal.rangeEnd !== undefined
                                                        && cal._sameDay(modelData, cal.rangeEnd)
                            readonly property bool _hasSpan: _rangeMode
                                                          && cal.rangeStart !== undefined && cal.rangeEnd !== undefined
                                                          && cal._dayNum(cal.rangeEnd) > cal._dayNum(cal.rangeStart)
                            readonly property bool _isMiddle: _hasSpan
                                                           && cal._dayNum(modelData) > cal._dayNum(cal.rangeStart)
                                                           && cal._dayNum(modelData) < cal._dayNum(cal.rangeEnd)
                            readonly property bool _isEndpoint: _isStart || _isEnd
                            // 是否属于区间连接带(起/中/止,且确有跨度)。
                            readonly property bool _inSpan: _hasSpan && (_isStart || _isMiddle || _isEnd)

                            // 主色药丸:单选选中日 或 区间端点(bg-primary / text-primary-foreground)。
                            readonly property bool _pillPrimary: isSelectedSingle || _isEndpoint
                            // muted 药丸:今天 / hover(且非端点、非中间日)。
                            readonly property bool _pillMuted: !_pillPrimary && !_isMiddle
                                                            && (isToday || hover.hovered)

                            // ---- 区间连接带(muted)----
                            // 起/中/止均整格铺满同一个带,外侧圆角按「区间端点」或「周界」决定:
                            //   · 左圆角:本格是区间起点,或位于每周行首(周日)——即左侧无同周相邻区间格;
                            //   · 右圆角:本格是区间终点,或位于每周行末(周六)。
                            // 这样跨周时每段周内连接带两端都是圆角(对齐官网),端点再叠主色药丸。
                            Rectangle {
                                visible: dayCell._inSpan
                                anchors.fill: parent
                                color: Theme.muted
                                readonly property bool _roundL: dayCell._isStart || dayCell.modelData.getDay() === 0
                                readonly property bool _roundR: dayCell._isEnd || dayCell.modelData.getDay() === 6
                                topLeftRadius:     _roundL ? Theme.radiusMd : 0
                                bottomLeftRadius:  _roundL ? Theme.radiusMd : 0
                                topRightRadius:    _roundR ? Theme.radiusMd : 0
                                bottomRightRadius: _roundR ? Theme.radiusMd : 0
                            }

                            // ---- 每格药丸(圆角 radius-md,覆于连接带之上)----
                            Rectangle {
                                anchors.fill: parent
                                radius: Theme.radiusMd   // --cell-radius = radius-md
                                visible: dayCell.shown && (dayCell._pillPrimary || dayCell._pillMuted)
                                color: dayCell._pillPrimary ? Theme.primary : Theme.muted
                            }

                            // ---- 日期数字 ----
                            Text {
                                anchors.centerIn: parent
                                text: dayCell.modelData.getDate()
                                font.pixelSize: Theme.textXs
                                color: dayCell._pillPrimary ? Theme.primaryForeground
                                     : dayCell.inMonth ? Theme.foreground
                                     : Theme.mutedForeground
                            }

                            HoverHandler { id: hover; enabled: dayCell.shown }
                            TapHandler {
                                enabled: dayCell.shown
                                // 单月点外月补格 → 跳月;多月视图固定不重定位。
                                onTapped: cal._pick(dayCell.modelData, !dayCell.inMonth && cal.numberOfMonths === 1)
                            }
                        }
                    }
                }
            }
        }
    }

    // ==== 共享上/下月导航(覆于首行 caption 之上,首列左端 + 末列右端)====
    // 每次移动 1 个月(react-day-picker 默认 pagedNavigation=false)。
    IconButton {
        variant: IconButton.Ghost
        size: IconButton.Small
        iconName: "chevron-left"
        x: monthsRow.x
        y: cal._pad + (cal.cellSize - height) / 2
        onClicked: cal.displayMonth = new Date(cal._year, cal._month - 1, 1)
    }
    IconButton {
        variant: IconButton.Ghost
        size: IconButton.Small
        iconName: "chevron-right"
        x: monthsRow.x + monthsRow.width - width
        y: cal._pad + (cal.cellSize - height) / 2
        onClicked: cal.displayMonth = new Date(cal._year, cal._month + 1, 1)
    }
}
