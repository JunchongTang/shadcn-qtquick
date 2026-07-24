# shadcn-qtquick Issues

> **Living Document** — 手工缺陷记录,用于对照回归。
> **位置(Location)**:优先用示例卡「复制路径」按钮产出的格式 `Component/组件/示例`(例如 `Component/ButtonGroup/Orientation`),可直接粘贴;非示例问题(组件库/基建/文档)写模块路径,如 `src/Theme` 或 `examples/gallery/Gallery`。
> **状态**:🆕 新建 | 🔍 分析中 | 🛠 修复中 | ✅ 已修复 | 🚫 不修 | ❓ 无法复现
> **严重级**:P0 崩溃/数据丢失 | P1 功能不可用 | P2 功能可用但行为错误 | P3 体验/视觉问题
> 编号 `#NNN` 递增、永不复用;修复后保留条目、更新状态与「修复」字段。截图放 `./assets/issue-NNN.png`。

## 索引

| # | 标题 | 位置 | 严重 | 状态 |
|---|---|---|---|---|
| [#001](#001-大量组件-hover-背景由黑变灰) | 大量组件 hover 背景由黑变灰 | src/*(15 组件) | P3 | ✅ |
| [#002](#002-菜单列表项-hover-出现深色拖影动画) | 菜单/列表项 hover 出现深色拖影动画 | Component/Menu 等 | P3 | ✅ |
| [#003](#003-alertdialog-顶部两角为直角) | AlertDialog 顶部两角为直角 | Component/AlertDialog | P2 | ✅ |
| [#004](#004-dialog-底部按钮溢出边界) | Dialog 底部按钮溢出边界 | Component/Dialog | P2 | ✅ |
| [#005](#005-tabs-垂直模式激活胶囊过窄) | Tabs 垂直模式激活胶囊过窄 | Component/Tabs | P3 | ✅ |
| [#006](#006-弹窗开场图标背景黑闪) | 弹窗开场「图标背景黑闪」 | Component/AlertDialog · Component/Dialog | P2 | ✅ |
| [#007](#007-头像媒体图片未做圆形圆角裁剪) | 头像/媒体图片未做圆形/圆角裁剪 | Component/Avatar 等 | P2 | ✅ |
| [#008](#008-面包屑-dropdown-点箭头无反应) | 面包屑 Dropdown 点箭头无反应 | Component/Breadcrumb/Dropdown | P2 | ✅ |
| [#009](#009-bubble-分组内气泡背景过窄文本溢出) | Bubble 分组内气泡背景过窄、文本溢出 | Component/Bubble/Bubble | P2 | ✅ |
| [#010](#010-buttongrouporientation-竖向整组不显示) | ButtonGroup 竖向整组不显示 | Component/ButtonGroup/Orientation | P1 | ✅ |
| [#011](#011-buttongroupinput-焦点环右侧圆角--右共享边不同步) | ButtonGroup/Input 焦点环右侧圆角 + 右边不同步 | Component/ButtonGroup/Input | P3 | ✅ |
| [#012](#012-buttongroupinput-点右侧按钮输入框不失焦) | ButtonGroup/Input 点右侧按钮输入框不失焦 | Component/ButtonGroup/Input | P2 | ✅ |
| [#013](#013-buttongroupselect-鼠标点击显示了焦点环) | ButtonGroup/Select 鼠标点击显示了焦点环 | Component/ButtonGroup/Select | P3 | ✅ |
| [#014](#014-buttongroupnested-与官网不一致实现成两段式) | ButtonGroup/Nested 与官网不一致(两段式) | Component/ButtonGroup/Nested | P2 | ✅ |
| [#015](#015-calendar-range-跨周中间行两端无圆角) | Calendar Range 跨周中间行两端无圆角 | Component/Calendar/RangeTwoMonths | P3 | ✅ |
| [#016](#016-示例卡无响应式宽度窄窗内容溢出) | 示例卡无响应式宽度(窄窗内容溢出) | examples/gallery/Gallery | P3 | ✅ |
| [#017](#017-calendar-dropdown-月年下拉显示了焦点环) | Calendar Dropdown 月/年下拉显示了焦点环 | Component/Calendar/DropdownCaption | P3 | ✅ |
| [#018](#018-carousel-导航按钮与卡片内容重叠) | Carousel 导航按钮与卡片内容重叠 | Component/Carousel/Basic | P2 | ✅ |
| [#019](#019-键盘支持tab-聚焦焦点环焦点环仅键盘显示) | 键盘支持:Tab 聚焦 + 焦点环仅键盘显示 | src/*(交互控件) | P2 | ✅ |
| [#020](#020-combobox-与官网不一致按钮弹层搜索框顺序) | Combobox 与官网不一致(按钮/弹层搜索框/顺序) | Component/Combobox | P2 | ✅ |
| [#021](#021-菜单项文本被省略菜单不按最宽项撑宽) | 菜单项文本被省略(菜单不按最宽项撑宽) | Component/ContextMenu/Checkboxes 等 | P2 | ✅ |
| [#022](#022-侧栏不响应式窄屏挤占内容左边距过小) | 侧栏不响应式(窄屏挤占内容)+ 左边距过小 | examples/gallery/Gallery · DocsSidebar | P2 | ✅ |
| [#023](#023-table-重做为-tableview-高性能版) | Table 重做为 TableView 高性能版(model/列定义驱动) | Component/Table · Component/DataTable | P2 | ✅ |
| [#024](#024-datatable-列显隐后列错位重复渲染) | DataTable 列显隐后列错位/重复渲染 | Component/DataTable/Demo | P1 | ✅ |
| [#025](#025-datepicker-图标位置错点击本体无法关闭弹层) | DatePicker 图标位置错 + 点击本体无法关闭弹层 | Component/DatePicker | P2 | ✅ |
| [#026](#026-dialog-footer-无分隔线背景遮罩非高斯模糊) | Dialog footer 无分隔线/背景 + 遮罩非高斯模糊 | Component/Dialog | P3 | ✅ |
| [#027](#027-drawer-示例完整度低) | Drawer 示例完整度低(缺 Move Goal/方向/响应式) | Component/Drawer | P3 | ✅ |
| [#028](#028-toggletogglegroup-默认变体误为-outline枚举名冲突) | Toggle/ToggleGroup 默认变体误为 Outline(枚举名冲突) | Component/Toggle · Component/ToggleGroup | P2 | ✅ |
| [#029](#029-bubblereactions-顶部反应渲染到了底部继承-item-枚举冲突) | BubbleReactions 顶部反应渲染到底部(继承 Item 枚举冲突) | Component/Bubble · Component/HoverCard | P2 | ✅ |

---

### #001 大量组件 hover 背景由黑变灰

- **位置**: src/*(Button/IconButton/Toggle/TabButton/Combobox/Menubar/NavigationMenu/Checkbox/RadioButton/Carousel/DatePicker/... 共 15 处)
- **严重级**: P3
- **复现步骤**: 鼠标划过带 hover 变色的组件(如 Ghost/Outline 按钮)。
- **预期行为**: 静止色 → hover 色平滑过渡,无中间深色。
- **实际行为**: 过渡中先闪一下半透明深灰/黑,再到目标色,观感脏。
- **分析/根因**: 静止色用了 `"transparent"`,在 QML 里等于 `Qt.rgba(0,0,0,0)`(透明**黑**);`ColorAnimation` 对 RGBA 线性插值,从透明黑→不透明目标色途经半透明黑 → 深色闪。
- **修复**: 静止态改用 `Theme.alpha(<hover色>, 0)`(RGB 与目标一致、仅 alpha 变化),消除中间深色。

### #002 菜单/列表项 hover 出现深色拖影动画

- **位置**: Component/Menu 及其它含列表项的组件
- **严重级**: P3
- **复现步骤**: 光标快速划过菜单项。
- **预期行为**: 官方无该动画,hover 即时高亮。
- **实际行为**: 每项执行深色 `Behavior on color` 过渡,划过一串留下"拖影",很脏。
- **修复**: 移除列表/菜单项上的 `Behavior on color`。

### #003 AlertDialog 顶部两角为直角

- **位置**: Component/AlertDialog
- **严重级**: P2
- **复现步骤**: 打开任意 AlertDialog,看顶部两角。
- **预期行为**: 四角统一 `rounded-xl`。
- **实际行为**: 顶部两角为直角,盖住圆角。
- **分析/根因**: 基类 `Dialog` 因 `title` 非空自动生成带默认底色/直角的标题栏。
- **修复**: `header: null; footer: null`,header/footer 全部收进 contentItem。

### #004 Dialog 底部按钮溢出边界

- **位置**: Component/Dialog
- **严重级**: P2
- **复现步骤**: 打开带 footer 按钮的 Dialog。
- **预期行为**: footer 按钮在内边距内、不贴边。
- **实际行为**: 按钮溢出到弹窗边界外。
- **分析/根因**: 基类 footer 槽为通栏无内边距。
- **修复**: footer 包一层带 `space4` 内边距的容器,并绑定唯一子项宽度以支持右对齐。

### #005 Tabs 垂直模式激活胶囊过窄

- **位置**: Component/Tabs
- **严重级**: P3
- **复现步骤**: 使用 `vertical` 的 Tabs。
- **预期行为**: 激活胶囊与 muted 背景等宽对齐。
- **实际行为**: 胶囊过窄。
- **修复**: 竖向时 `width: ListView.view.width`(用 width 而非 implicitWidth,避免绑定环)。

### #006 弹窗开场「图标背景黑闪」

- **位置**: Component/AlertDialog · Component/Dialog
- **严重级**: P2
- **复现步骤**: 打开 AlertDialog(尤其带 media 图标的)。
- **预期行为**: 面板平滑缩放弹入,无黑闪。
- **实际行为**: 开场瞬间面板(尤其实心的图标底块)发黑一下。
- **分析/根因**: 入场 `opacity` 从 0 淡入,浅色面板压在 `black/80` 模态遮罩上,低透明度阶段透出黑遮罩;实心图标底块 darkening 最明显。
- **修复**: 入场只做 `scale`(0.95→1)、面板全程不透明;出现感由模态遮罩自身淡入提供。

### #007 头像/媒体图片未做圆形/圆角裁剪

- **位置**: Component/Avatar(及 Attachment/Item/Message 的媒体图)
- **严重级**: P2
- **复现步骤**: 看 Avatar Group / 各媒体缩略图。
- **预期行为**: 头像正圆、媒体图按圆角裁剪。
- **实际行为**: 图片是方的 / 圆角处是直角。
- **分析/根因**: `Rectangle.clip` 只按矩形边界裁剪,不理会 `radius`。
- **修复**: 新增 `RoundedImage`(离屏图层 + `MultiEffect` 圆角遮罩),Avatar/AttachmentMedia/ItemMedia/MessageContent 改用之。

### #008 面包屑 Dropdown 点箭头无反应

- **位置**: Component/Breadcrumb/Dropdown
- **严重级**: P2
- **复现步骤**: 点击 "Components ⌄" 的下拉箭头。
- **预期行为**: 点文本或箭头都能弹出菜单。
- **实际行为**: 点文本能弹,点箭头无反应。
- **分析/根因**: `BreadcrumbLink` 的 `TapHandler` 只覆盖文本,箭头是旁边无处理的独立图标。
- **修复**: 把文本+箭头合成单个触发区(共用一个 HoverHandler/TapHandler),对齐官方 DropdownMenuTrigger。

### #009 Bubble 分组内气泡背景过窄、文本溢出

- **位置**: Component/Bubble/Bubble
- **严重级**: P2
- **复现步骤**: 看 Demo 里 BubbleGroup 内的左侧气泡。
- **预期行为**: 背景包住文本、按 max-w-80% 换行。
- **实际行为**: 背景塌成窄条,文本溢出到背景外。
- **分析/根因**: `max-width` 基准取 `_bubble.parent.width`;组内父项是 `fillWidth` 的 BubbleGroup,其宽度由子项隐式宽反推 → 与子项形成绑定环、被断成 0。
- **修复**: 基准上溯到真正的会话列(识别 `isBubbleGroup` 标记跳过组);并补 `clip: true`(overflow-hidden)兜底。

### #010 ButtonGroup 竖向整组不显示

- **位置**: Component/ButtonGroup/Orientation
- **严重级**: P1
- **复现步骤**: 打开 Orientation 示例(`orientation: Vertical`)。
- **预期行为**: 竖排两个图标按钮相接显示。
- **实际行为**: 整组空白。
- **分析/根因**: `Grid` 用 `_big:1000` 填另一维;竖向 `rows:1000` 会真的预留 1000 行,叠加 `spacing:-1`(999 个负间距)把高度塌掉。
- **修复**: 另一维改 `-1`(自动):`rows: vertical ? -1 : 1`、`columns: vertical ? 1 : -1`。

### #011 ButtonGroup/Input 焦点环右侧圆角 + 右共享边不同步

- **位置**: Component/ButtonGroup/Input
- **严重级**: P3
- **复现步骤**: 聚焦分组里的输入框。
- **预期行为**: 焦点环相邻侧为直角;四边同为 ring 色。
- **实际行为**: 焦点环右侧仍圆角;右边框被邻居边框盖住、颜色不同步。
- **分析/根因**: `FocusRing` 只有统一 `radius`;`spacing:-1` 下共享边被后绘制的按钮边框遮住。
- **修复**: `FocusRing` 加逐角半径(随背景各角);Input 聚焦时 `z:10` 抬起盖住共享边(对标 `focus-visible:z-10`)。

### #012 ButtonGroup/Input 点右侧按钮输入框不失焦

- **位置**: Component/ButtonGroup/Input
- **严重级**: P2
- **复现步骤**: 聚焦输入框后点右侧按钮。
- **预期行为**: 输入框失焦(对标 web 点按钮夺焦)。
- **实际行为**: 输入框仍保持焦点。
- **分析/根因**: Button 未设 `focusPolicy`,点击不夺焦。
- **修复**: Button/IconButton 加 `focusPolicy: Qt.StrongFocus`;焦点环改用 `visualFocus` 门控(鼠标点击不显环,仅键盘 Tab 显环 = focus-visible)。

### #013 ButtonGroup/Select 鼠标点击显示了焦点环

- **位置**: Component/ButtonGroup/Select
- **严重级**: P3
- **复现步骤**: 鼠标点击打开分组里的 Select。
- **预期行为**: 官网点击打开不显焦点环(focus-visible 仅键盘)。
- **实际行为**: 我们的触发器显示了焦点环/ring 色边框。
- **分析/根因**: 环与边框用 `activeFocus`(任何聚焦都亮),而非 focus-visible 语义。
- **修复**: Select 的 border/FocusRing/z 改用 `visualFocus`(仅键盘)。注:文本 Input 点击也算 focus-visible,故 Input 仍用 `activeFocus`、点击显环是对的。

### #014 ButtonGroup/Nested 与官网不一致(两段式)

- **位置**: Component/ButtonGroup/Nested
- **严重级**: P2
- **复现步骤**: 看 Nested 示例。
- **预期行为**: `[+]` 图标按钮 + 一个 InputGroup(输入框内 inline-end 内嵌语音图标)。
- **实际行为**: 做成了「输入框 + 独立图标按钮」两段式。
- **修复**: 内层改用 `InputGroup` + `InputGroupAddon(InlineEnd)` + `InputGroupButton`(audio-lines 图标)。

### #015 Calendar Range 跨周中间行两端无圆角

- **位置**: Component/Calendar/RangeTwoMonths
- **严重级**: P3
- **复现步骤**: 选一个跨周(>1 周)的区间。
- **预期行为**: 每周行的连接带两端(周首/周末)为圆角,像分段药丸。
- **实际行为**: 中间行两端是直角。
- **分析/根因**: 中间日连接带整格方形铺满,周界处未做外侧圆角。
- **修复**: 统一成一个连接带,按「区间端点 / 周首(周日)/ 周末(周六)」决定外侧圆角。

### #016 示例卡无响应式宽度(窄窗内容溢出)

- **位置**: examples/gallery/Gallery(ExampleCard)
- **严重级**: P3
- **复现步骤**: 把窗口缩到约一半宽。
- **预期行为**: 内容随视口收缩,右侧「复制路径」按钮仍可见。
- **实际行为**: 内容不收缩、横向溢出,复制按钮被挤出视口。
- **分析/根因**: 内容宽度绑到了非视口的 `parent.width`,产生横向滚动。
- **修复**: `ScrollView.contentWidth: availableWidth`(禁横滚)、内容宽跟随视口可用宽、窄屏减小左右留白、最大宽 760。

### #017 Calendar Dropdown 月/年下拉显示了焦点环

- **位置**: Component/Calendar/DropdownCaption
- **严重级**: P3
- **复现步骤**: 打开 DropdownCaption 示例,点击月份/年份下拉。
- **预期行为**: 官网月/年下拉无焦点环(focus-visible 仅键盘)。
- **实际行为**: 我们的两个下拉显示了焦点环/ring 色边框。
- **分析/根因**: 标题下拉用的是 `NativeSelect`,其边框/环用 `activeFocus`(任何聚焦都亮),而非 focus-visible 语义(同 [#013](#013-buttongroupselect-鼠标点击显示了焦点环) 但组件不同)。
- **修复**: NativeSelect 的 border/FocusRing 改用 `visualFocus`(仅键盘)。

### #018 Carousel 导航按钮与卡片内容重叠

- **位置**: Component/Carousel/Basic
- **严重级**: P2
- **复现步骤**: 打开 Carousel Basic 示例。
- **预期行为**: 上一/下一按钮位于内容卡片外侧、留间隙(对标官方 `-left-12`/`-right-12`)。
- **实际行为**: 垂直水平句均是下一按钮半探出、盖住内容卡片。
- **分析/根因**: 按钮定位为 `x: -width/2` / `x: width - width/2`(半探出)。
- **修复**: 按钮移到内容外侧并留 `_navGap`(12);相应加宽/加高各 carousel demo 容器以容纳按钮。
- **追加修复**: 移出按钮后发现左右间隙不对称(左比右宽一个 gap)。根因:`CarouselItem` 用单侧左内边距(`holder.x = gap`,embla 的 `pl`)造间隔但**缺 `-ml` 补偿**,把 basis-full 幻灯片整体推向一侧。改为由 `ListView.spacing` 提供对称间隔、条目内容满铺 → 幻灯片满幅居中、两侧到按钮间隙对称。

### #019 键盘支持:Tab 聚焦 + 焦点环仅键盘显示

- **位置**: src/*(Checkbox/RadioButton/Switch/Toggle/TabButton/Slider/RangeSlider/Select/NativeSelect/Combobox/Carousel/DatePicker/DateRangePicker · Button/IconButton 见 [#012](#012-buttongroupinput-点右侧按钮输入框不失焦))
- **严重级**: P2
- **复现步骤**: 用键盘 Tab 在示例页面各控件间移动;按 Space/Enter 触发。
- **预期行为**: Tab 可依次聚焦各交互控件并显焦点环(仅键盘);Space/Enter 触发按钮/切换,含按下态;鼠标点击不显环。
- **实际行为(修复前)**: 仅 Button/IconButton 显式可 Tab;多个控件的环用 `activeFocus`,鼠标点击也显环(非 focus-visible)。
- **分析/根因**: 未统一 `focus-visible` 语义;`focusPolicy` 依赖基类默认、未显式声明。
- **修复**: 交互叶子控件显式 `focusPolicy: Qt.StrongFocus`;按钮/下拉类焦点环统一用 `visualFocus`(仅键盘),文本输入类保留 `activeFocus`。Space/Enter 激活与按下态由继承的 `AbstractButton` 基类自带。约定见记忆 focus-visible-ring-convention。
- **追加修复(应用级)**: 真机实测按 Tab 完全无反应。两个根因:
  1. **无初始焦点**:Qt Quick 特性——场景中无任何项持 `activeFocus` 时按 Tab 不启动导航。修复:启动时给不可见占位项 `kbStart.forceActiveFocus()`;左侧导航从 `Repeater`+`TapHandler` 重写为 `ListView`(↑↓ 移动、Enter/Space 打开、键盘光标行显环、鼠标点击不抢焦)。
  2. **macOS 只 Tab 文本框**:macOS 默认让 `QStyleHints::tabFocusBehavior = TabFocusTextControls`,Qt 主动跳过按钮(vanilla 最小程序 `examples/focus_test.qml` 复现:只有 TextField 可聚焦)。修复:`main.cpp` 中 `app.styleHints()->setTabFocusBehavior(Qt::TabFocusAllControls)`,应用内覆盖,无需用户改系统设置。
- **待办(后续)**: 复合控件的方向键内部导航(Tabs 左右、RadioGroup 上下、Menu 上下、Select 列表)已部分依赖基类,需逐一真机核对补齐;侧栏滚动条(ListView 改造后暂无可视滚动条,滚轮/键盘滚动正常)。

### #020 Combobox 与官网不一致(按钮/弹层搜索框/顺序)

- **位置**: Component/Combobox
- **严重级**: P2
- **复现步骤**: 对比官网 Combobox 页。
- **预期行为(base-nova)**: 触发器本身是**可编辑输入框**(打字过滤、显光标/焦点环);弹层里**只有列表 + 空态、无独立搜索框**;卡片顺序 Basic/Multiple/Clear/Groups/Custom/Invalid/Disabled/Input Group。
- **实际行为(修复前)**: 触发器是 Outline **按钮**、不可编辑;弹层顶部有独立搜索框;卡片顺序/集合与官网不同(含无关的 Status,缺 Clear/Custom/Input Group)。
- **修复**:
  - 重写 `src/Combobox.qml` 为「可编辑 `TextField` 触发器 + 纯列表弹层」;新增 `showClear`(清除按钮)、`leadingIcon`(前置图标)、条目 `description`(两行条目)能力;`searchPlaceholder` 保留为兼容用无操作。
  - 重排 `PageCombobox.qml` 顺序,新增 Clear/Custom/Input Group 示例,移除 Status;各 demo 对齐官方文案/数据。
- **追加修复**: ①下拉箭头 `chevrons-up-down` → `chevron-down`;②箭头/清除做成小方按钮、hover 显 accent 底;③弹层关闭(点外部/空白)时输入框 `focus=false` 失焦、焦点环消失;④Multiple 内联输入宽度由 `flow.width - x`(循环/误换行致容器虚高两行)改为固定 `width:90`,恢复一行。
- **待办**: 键盘打字过滤/选择/↑↓/Enter、hover 背景、点外部失焦等交互需真机复核(离屏无法验证)。

### #021 菜单项文本被省略(菜单不按最宽项撑宽)

- **位置**: Component/ContextMenu/Checkboxes(及所有 Menu/DropdownMenu/Menubar 长文本项)
- **严重级**: P2
- **复现步骤**: 打开含较长文本的菜单(如 "Show Bookmarks Bar")。
- **预期行为**: 菜单宽度按最宽项自增,文本完整显示。
- **实际行为**: 菜单卡在 `min-w`(128),三项文本全被省略成 "Show Book…"。
- **分析/根因**: `C.Menu` 不会自动按最宽项撑宽——其 `ListView` contentItem 不上报内容宽,菜单宽只取了 `background` 的 min-w;单纯给 item 设大 `implicitWidth` 也无效(实测强制 320 仍不变)。
- **修复**: `Menu.qml` 显式 `contentWidth = 遍历 itemAt(i) 的最大 implicitWidth`;并给 `MenuItem`/`MenuCheckboxItem`/`MenuRadioItem` 用 `TextMetrics` 上报准确 `implicitWidth`(含图标/快捷键/子菜单箭头/右侧勾选 gutter)。

### #022 侧栏不响应式(窄屏挤占内容)+ 左边距过小

- **位置**: examples/gallery/Gallery · examples/gallery/DocsSidebar
- **严重级**: P2
- **复现步骤**: 把窗口缩到半屏,看 Table 等宽内容页。
- **预期行为**: 窄屏时侧栏收起、顶栏出汉堡按钮开抽屉,内容区拿到全宽;侧栏内容左边距与官网一致。
- **实际行为(修复前)**: 侧栏恒占 240,半屏时内容(如 Table)显示不全;侧栏内容左边距过小、贴窗口左缘。
- **修复**: Gallery 加 `compact = width < 860` 断点——窄屏隐藏内联侧栏、顶栏出 `menu` 汉堡按钮打开 `QC.Drawer`(左侧抽屉,选中后自动关闭、变宽自动收起);DocsSidebar 内容加 `anchors.leftMargin: 12`。

### #023 Table 重做为 TableView 高性能版(model/列定义驱动)

- **位置**: Component/Table · Component/DataTable(src/Table.qml、TableColumn.qml)
- **严重级**: P2(能力/架构)
- **背景**: 旧 Table 是声明式基元(Repeater 手写行/格),数据量有限、列宽不可调、还原度一般。
- **改造**: 重做为 **QtQuick TableView 打底**(虚拟化):
  - 数据 `model`:JS 数组 / QML `TableModel` / C++ `QAbstractItemModel`;
  - 列 `columns`(JS)或声明式 `TableColumn`(`columnItems`),属性:`title/key/role/width/fillWidth/minWidth/maxWidth/align/format/medium/cellDelegate/headerDelegate`;
  - **自绘表头**(普通 Row)+ 稳定 `DragHandler` 列宽拖拽(末列无手柄、恒定短分隔线);Qt 内建 `resizableColumns` 命中区太窄+和单元格抢事件,弃用;
  - 列宽:固定 / fill 均分 / min-max 夹取 + **兜底铺满**(剩余补末列 → 行线完整无空白);
  - `selectedRows`(行高亮)、`footerData`(合计行)、`caption`、`emptyText`(空态);
  - 行级 hover 协调、`rowClicked`。
- **迁移**: 全部 8 个 demo(table Demo/Actions/Selection + data-table Basic/Demo/RowSelection/Sorting/WithPagination)改为新 API;删除旧基元 7 文件(TableRow/TableCell/TableHeader/TableBody/TableFooter/TableHead/TableCaption)。
- **测试**: `tests/tst_Table.qml`(列定义/固定+fill 宽/兜底铺满/min-max 夹取/行数/选择),ctest 通过。

### #024 DataTable 列显隐后列错位/重复渲染

- **位置**: Component/DataTable/Demo(交互数据表「Columns」列显隐)
- **严重级**: P1
- **复现步骤**: 打开「Columns」菜单取消某一列(如 Status)→ 每行出现两个「⋯」操作按钮且都能弹菜单;再把所有列重新勾选 → 第三列(Amount)不显示,Status 列里错显 Email 徽章、Email 列错显金额(整体错位一列)。
- **预期行为**: 显隐任意列后,表头/数据/操作列一一对应,无重复、无错位。
- **实际行为**: 表头列数正确,但**数据模型列数慢一拍**,导致表头(N 列)与内部模型(N∓1 列)错位;残留旧列 delegate 造成「⋯」重复。
- **分析/根因**: 两处叠加——
  1. `Table` 的生效列集合是派生属性 `readonly property var _cols`(由 `columns`/`columnItems` 计算)。在 `onColumnsChanged` 处理器里 `_cols` 绑定**尚未标脏重算**(QML 惰性求值),`_rebuild()` 读到的是**上一次的旧列集合**——重建的内部 `TableModel` 列数始终滞后一步;而表头/单元格通过 `_cols` 绑定在渲染时惰性求值拿到的是新值 → 表头列数(新)≠ 模型列数(旧)→ 列错位。
  2. `format` 函数在切列瞬间 `_def`/`_raw` 绑定更新有先后,可能短暂收到另一列的值(类型不符)→ 抛异常刷屏。
- **修复**:
  - 新增 `_currentCols()`,在 `_rebuild()`/`_recompute()` 里**直接从源属性 `columns`/`columnItems` 现算**列集合(信号处理器中源属性已是最新值),不再读滞后的 `_cols` 缓存 → 模型/表头列数始终一致。
  - 列集合变化时清空按索引记录的拖拽覆盖宽 `_overrides`(旧索引已错配)。
  - 默认文本单元格的 `format` 调用用 `try` 包裹,过渡帧类型不符时静默回退原值,消除刷屏。
- **回归测试**: `tests/tst_Table.qml` 新增 `test_dynamic_column_change`(运行时增减列后断言 `view.columns` 与 `_widths.length` 同步)与 `test_declarative_columns`(声明式 `columnItems` 路径)。
- **附带**: 补齐 `TableColumn` 的 `cellDelegate`/`headerDelegate` 属性;`data-table/Basic` 改用声明式 `columnItems + TableColumn` 展示该写法。

### #025 DatePicker 图标位置错 + 点击本体无法关闭弹层

- **位置**: Component/DatePicker(含 DateRangePicker、date-picker/Presets)
- **严重级**: P2
- **复现步骤**: (1) 观察触发器图标位置;(2) 点触发器打开日历弹层,再点触发器本体想关闭。
- **预期行为**: base-mira 触发器为「左对齐文本 + 右侧 chevron-down」;点击本体可 toggle(再点即关)。
- **实际行为**: 左侧放了 calendar 图标(与 base-mira 不符);点击本体只会开、无法关(反复点保持打开)。
- **分析/根因**: (1) 图标放左且用 calendar,应改右侧 chevron-down。(2) Popover 的 `CloseOnPressOutside` 在 press 阶段先关闭弹层 → 到 release 触发 `onClicked` 时 `pop.opened` 已为 false → 朴素的 `opened ? close : open` 会重新打开,表现为「关不掉」。
- **修复**: 触发器内容改为「文本(fillWidth 左对齐)+ 尾随 chevron-down(opacity 0.5)」;`onClicked` 加「刚关闭时间戳」守卫——若本次点击正是那次 press-outside 关闭的来源(250ms 内)则不重开。DatePicker/DateRangePicker/Presets 三处同修。

### #026 Dialog footer 无分隔线/背景 + 遮罩非高斯模糊

- **位置**: Component/Dialog(含 CustomCloseButton 等所有弹窗)
- **严重级**: P3
- **复现步骤**: 打开任意带 footer 的 Dialog,看 footer 与正文的分界;看遮罩效果。
- **预期行为**: footer 与正文间有分隔线、footer 背景较正文略深(muted);遮罩为背景内容高斯模糊(backdrop-blur)。
- **实际行为**: footer 与正文同底、无分隔线;遮罩仅为半透黑(black/80),无模糊。
- **修复**: 遮罩改为 `ShaderEffectSource` 抓取窗口内容(排除 overlay 自身以防递归)→ `MultiEffect` 高斯模糊 + 轻 scrim(black/25)。footer 初版用「圆角 muted 矩形 + 方顶覆盖」实现底角,与弹窗 1px 边框错位、看得出 footer 自己的边框(不一体)。**二次修正**:footer 只保留「顶部 1px 分隔线 + 一块 muted 填充」,填充按边框宽度内缩、底角用逐角半径 `radiusXl - border` 贴合弹窗内壁 → 无接缝、边框一体;并对正文内容区开启 `contentItem.clip`(长文本不再透过半透明 footer 叠影、不溢出圆角)。
- **备注**: 模糊为 GPU shader,offscreen 软件后端不出效果、降级为「内容透出 + scrim」;真机(Metal/GL)方可见模糊,待真机确认。

### #027 Drawer 示例完整度低

- **位置**: Component/Drawer/Basic(及整页)
- **严重级**: P3
- **复现步骤**: 打开 Drawer 文档页。
- **预期行为**: 对齐官网:主 demo 为「Move Goal」(目标步进器 + 活动柱状图),另有方向变体与响应式对话框示例。
- **实际行为**: 仅一个简单的底部抽屉,功能与官网差距大。
- **修复**: Basic 重做为忠实的「Move Goal」(圆形 -/+ 步进器 + 大号数值 + 柱状图 + Submit/Cancel,内容 mx-auto max-w-sm 居中)。对齐官网示例集,补齐示例卡至 6 个:Directions(四向)、Swipe Handle(抓手)、Nested(抽屉内开抽屉)、Non Modal(`modal:false`、页面可交互)、Responsive Dialog(宽屏 Dialog/窄屏 Drawer)。官方「Snap Points」因 Qt Quick Controls Drawer 无原生吸附点、不做低保真替代,页面注释说明跳过。

### #028 Toggle/ToggleGroup 默认变体误为 Outline(枚举名冲突)

- **位置**: Component/Toggle · Component/ToggleGroup
- **严重级**: P2
- **复现步骤**: 放一个默认 `Toggle { text: "..." }`(不设 variant)。
- **预期行为**: 默认 variant=Default,透明底、无边框(仅 hover/选中显 muted)。
- **实际行为**: 默认 Toggle 带了一圈 outline 边框(等同 variant=Outline)。
- **分析/根因**: QML 会把同一类型下所有 enum 的成员**扁平化**进类型作用域。Toggle 同时声明 `enum Variant { Default, Outline }`(Default=0)与 `enum Size { Sm, Default, Lg }`(Default=1),两个 `Default` **同名不同值**;`Toggle.Default` 被解析为后者(Size.Default=1)。于是 `property int variant: Toggle.Default` 实际取到 1 = Variant.Outline → 默认就成了描边样式。ToggleGroup 同样问题。(Button/ShadItem 幸免:它们两个枚举的 Default 都排第一、同为 0。)
- **修复**: 把 Toggle/ToggleGroup 的 `enum Size` 重排为 `{ Default, Sm, Lg }`,使 `Default` 在两个枚举里都为 0、冲突消解为同值;命名引用(`Toggle.Sm/Lg`)不受影响。由单测 `tst_Toggle.qml::test_variant_border` 锁定(默认边框=0、Outline 边框=1)。
- **备注**: 通用教训——同一 QML 类型里**多个 enum 不要出现同名成员**,除非它们数值相同;否则扁平化后按声明顺序覆盖,静默取错值。

### #029 BubbleReactions 顶部反应渲染到了底部(继承 Item 枚举冲突)

- **位置**: Component/Bubble(BubbleReactions);同类隐患 Component/HoverCard
- **严重级**: P2
- **复现步骤**: `BubbleReactions { side: BubbleReactions.Top }`(想让反应贴在气泡顶部)。
- **预期行为**: 反应 pill 贴气泡上沿、上移 75%(`-0.75*height`)。
- **实际行为**: 仍渲染在底部(走了 `Bottom` 分支)。
- **分析/根因**: #028 的**继承版**。BubbleReactions 根类型是 `Item`,而 `Item` 自带 `enum TransformOrigin { TopLeft, Top=1, …, Bottom=7, … }`,其成员被扁平化进类型作用域。本组件又声明 `enum Side { Top, Bottom }`(应为 0/1)。于是 `BubbleReactions.Top` 被解析为 **Item.TransformOrigin.Top = 1**、`BubbleReactions.Bottom = Item.Bottom = 7`;而 y 绑定里的 `BubbleReactions.Top` 与属性默认/外部赋值在不同上下文解析不一致(一处取 Side.Top=0、一处取 Item.Top=1)→ `side === BubbleReactions.Top` 恒 false → 永远走底部分支。单测 `tst_Bubble::test_reactions_position` 捕获(顶部反应 y 实测 32.25,应为 -14.25)。
- **修复**: 把 `enum Side { Top, Bottom }` 重命名为 `{ Above, Below }`(Item 无 Above/Below,不冲突);同步默认值、y 绑定、QDoc、demo `bubble/Reactions.qml`、`tst_Bubble.qml`。
- **通用教训**: QML 枚举成员不仅会与**同类型内**其他枚举冲突(#028),还会与**继承来的基类枚举**冲突。Item 派生类型要避免用 `Top/Bottom/Left/Right/Center`(及 `TopLeft…` 等)作枚举成员名——它们与 `Item.TransformOrigin` 撞名。Popup/Drawer/ToolTip 派生类型不含该枚举,安全(故 Sheet/Tooltip/Popover 的 `Side/Align` 不受影响)。
- **同类待修**: HoverCard(根为 `Item`,`Side{Top,Right,Bottom,Left}` + `Align{…Center}`)存在同一隐患,当前无 demo/测试触发(潜伏);在其批次(Batch 3)一并改名修复。
