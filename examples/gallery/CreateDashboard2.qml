import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// Second live-preview page for the Create page — a 1:1 QML port of shadcn's
// registry `preview` block (apps/v4/registry/bases/base/blocks/preview). A
// horizontally-scrolling 7-column bento of ~31 cards that exercises the full
// base component set so the whole showcase re-themes through the Theme
// override layer. Column order and per-card content mirror index.tsx exactly
// (UIElements is rendered once, in column 2).
ScrollView {
    id: root
    clip: true
    // Size to the bento's natural extent so both axes scroll (the grid is wider
    // and taller than the preview viewport).
    contentWidth: bento.implicitWidth
    contentHeight: bento.implicitHeight

    // ---- Shared inline helpers (declared at root, not nested in a layout) ----

    // Muted rounded box == shadcn's <Item variant="muted">.
    component MutedBox: Rectangle {
        default property alias boxData: boxCol.data
        property int pad: 12
        Layout.fillWidth: true
        radius: Theme.radiusMd
        color: Theme.alpha(Theme.muted, 0.5)
        implicitHeight: boxCol.implicitHeight + pad * 2
        ColumnLayout {
            id: boxCol
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: parent.pad
            spacing: 8
        }
    }

    // Small uppercase muted label (== shadcn ItemDescription uppercase).
    component Kicker: Text {
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
        font.weight: Font.Medium
        font.letterSpacing: 0.6
    }
    component Stat: Text { color: Theme.foreground; font.weight: Font.DemiBold }
    component Muted: Text { color: Theme.mutedForeground; font.pixelSize: Theme.textSm }

    // Circular percentage gauge (== usage-card's inline <CircularGauge> SVG):
    // a faint full ring plus a primary-colored arc starting at 12 o'clock.
    component CircleGauge: Canvas {
        id: gauge
        property real percentage: 0
        property color ringColor: Theme.primary
        width: 16; height: 16
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            var cx = width / 2, cy = height / 2
            var r = width / 2 - 1.6
            ctx.lineWidth = 2.4
            ctx.lineCap = "round"
            // Faint background ring (opacity-20).
            ctx.globalAlpha = 0.2
            ctx.strokeStyle = ringColor
            ctx.beginPath(); ctx.arc(cx, cy, r, 0, 2 * Math.PI); ctx.stroke()
            // Foreground progress arc, from the top, clockwise.
            ctx.globalAlpha = 1
            var start = -Math.PI / 2
            var pct = Math.min(100, Math.max(0, percentage)) / 100
            ctx.beginPath(); ctx.arc(cx, cy, r, start, start + pct * 2 * Math.PI); ctx.stroke()
        }
        onPercentageChanged: requestPaint()
        onRingColorChanged: requestPaint()
        Component.onCompleted: requestPaint()
    }

    RowLayout {
        id: bento
        spacing: 16

        // ============================ Column 1 ============================
        // StyleOverview · TypographySpecimen · CodespacesCard · Invoice
        ColumnLayout {
            Layout.preferredWidth: 360
            Layout.minimumWidth: 360
            Layout.maximumWidth: 360
            Layout.alignment: Qt.AlignTop
            spacing: 16

            // ---- Style overview: title + description + colour swatches ----
            Card {
                Layout.fillWidth: true
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        Text {
                            text: qsTr("Mira - Geist")
                            color: Theme.foreground
                            font.pixelSize: Theme.text2xl
                            font.weight: Font.Medium
                            font.family: Theme.fontHeading
                        }
                        Text {
                            Layout.fillWidth: true
                            text: qsTr("Designers love packing quirky glyphs into test phrases. "
                                     + "This is a preview of the typography styles.")
                            color: Theme.mutedForeground
                            font.pixelSize: Theme.textBase
                            wrapMode: Text.Wrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                        }
                    }
                }
                CardContent {
                    Grid {
                        id: swatches
                        Layout.fillWidth: true
                        columns: 6
                        columnSpacing: 10
                        rowSpacing: 10
                        readonly property var _items: [
                            { name: "--background", color: Theme.background },
                            { name: "--foreground", color: Theme.foreground },
                            { name: "--primary",    color: Theme.primary },
                            { name: "--secondary",  color: Theme.secondary },
                            { name: "--muted",      color: Theme.muted },
                            { name: "--accent",     color: Theme.accent },
                            { name: "--border",     color: Theme.border },
                            { name: "--chart-1",    color: Theme.chart1 },
                            { name: "--chart-2",    color: Theme.chart2 },
                            { name: "--chart-3",    color: Theme.chart3 },
                            { name: "--chart-4",    color: Theme.chart4 },
                            { name: "--chart-5",    color: Theme.chart5 }
                        ]
                        readonly property real cell: (width - columnSpacing * 5) / 6
                        Repeater {
                            model: swatches._items
                            delegate: Column {
                                required property var modelData
                                width: swatches.cell
                                spacing: 4
                                Rectangle {
                                    width: parent.width
                                    height: width
                                    radius: Theme.radiusLg
                                    color: modelData.color
                                    border.width: 1
                                    border.color: Theme.border
                                }
                                Text {
                                    width: parent.width
                                    text: modelData.name
                                    color: Theme.mutedForeground
                                    font.family: Theme.fontMono
                                    font.pixelSize: 9
                                    elide: Text.ElideRight
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                        }
                    }
                }
            }

            // ---- Typography specimen ----
            Card {
                Layout.fillWidth: true
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        Kicker { text: qsTr("GEIST - GEIST") }
                        Text {
                            Layout.fillWidth: true
                            text: qsTr("Designing with rhythm and hierarchy.")
                            color: Theme.foreground
                            font.pixelSize: Theme.text2xl
                            font.weight: Font.Medium
                            font.family: Theme.fontHeading
                            wrapMode: Text.Wrap
                        }
                        Text {
                            Layout.fillWidth: true
                            text: qsTr("A strong body style keeps long-form content readable and "
                                     + "balances the visual weight of headings.")
                            color: Theme.mutedForeground
                            font.pixelSize: Theme.textSm
                            lineHeight: 1.5
                            wrapMode: Text.Wrap
                        }
                        Text {
                            Layout.fillWidth: true
                            text: qsTr("Thoughtful spacing and cadence help paragraphs scan quickly "
                                     + "without feeling dense.")
                            color: Theme.mutedForeground
                            font.pixelSize: Theme.textSm
                            lineHeight: 1.5
                            wrapMode: Text.Wrap
                        }
                    }
                }
                CardFooter {
                    Button { Layout.fillWidth: true; text: qsTr("Share Feedback"); variant: Button.Outline }
                }
            }

            // ---- Codespaces card (Tabs: Codespaces / Local) ----
            // Ports the visible "Codespaces" tab: header item, empty state and
            // the usage footer line. (The full Local-tab clone panel is elided.)
            Card {
                Layout.fillWidth: true
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Tabs {
                            id: codespacesTabs
                            Layout.fillWidth: true
                            TabButton { text: qsTr("Codespaces") }
                            TabButton { text: qsTr("Local") }
                        }

                        // Header row: title + description, create / more actions.
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.topMargin: 2
                            spacing: 8
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                Text { text: qsTr("Codespaces"); color: Theme.foreground; font.pixelSize: Theme.textSm; font.weight: Font.Medium }
                                Text { text: qsTr("Your workspaces in the cloud"); color: Theme.mutedForeground; font.pixelSize: Theme.textSm }
                            }
                            IconButton { iconName: "plus"; variant: IconButton.Ghost; size: IconButton.Small }
                            IconButton { iconName: "more-horizontal"; variant: IconButton.Ghost; size: IconButton.Small }
                        }

                        Separator { Layout.fillWidth: true }

                        // Empty state: no codespaces.
                        Empty {
                            Layout.fillWidth: true
                            EmptyHeader {
                                EmptyMedia { variant: EmptyMedia.Icon; iconName: "server" }
                                EmptyTitle { text: qsTr("No codespaces") }
                                EmptyDescription {
                                    text: qsTr("You don't have any codespaces with this repository checked out")
                                }
                            }
                            EmptyContent {
                                Button { Layout.alignment: Qt.AlignHCenter; text: qsTr("Create Codespace"); size: Button.Sm }
                                Button {
                                    Layout.alignment: Qt.AlignHCenter
                                    variant: Button.Link
                                    size: Button.Sm
                                    text: qsTr("Learn more about codespaces")
                                }
                            }
                        }

                        Separator { Layout.fillWidth: true }

                        Text {
                            Layout.fillWidth: true
                            text: qsTr("Codespace usage for this repository is paid for by shadcn.")
                            color: Theme.mutedForeground
                            font.pixelSize: Theme.textXs
                            wrapMode: Text.Wrap
                        }
                    }
                }
            }

            // ---- Invoice (table + totals) ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    RowLayout {
                        Layout.fillWidth: true
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            CardTitle { text: qsTr("Invoice #INV-2847") }
                            CardDescription { text: qsTr("Due March 30, 2026") }
                        }
                        Badge { variant: Badge.Secondary; text: qsTr("Pending"); Layout.alignment: Qt.AlignTop }
                    }
                }
                CardContent {
                    ColumnLayout {
                        id: invoiceTable
                        Layout.fillWidth: true
                        spacing: 0

                        readonly property int qtyW: 40
                        readonly property int rateW: 70
                        readonly property int amtW: 78

                        // Reusable numeric (right-aligned, tabular) cell text.
                        component Num: Text {
                            Layout.alignment: Qt.AlignRight
                            horizontalAlignment: Text.AlignRight
                            color: Theme.foreground
                            font.pixelSize: Theme.textSm
                            font.family: Theme.fontMono
                        }

                        property var _rows: [
                            { item: qsTr("Design System License"), qty: "1",  rate: "$499.00", amt: "$499.00"   },
                            { item: qsTr("Priority Support"),       qty: "12", rate: "$99.00",  amt: "$1,188.00" },
                            { item: qsTr("Custom Components"),      qty: "3",  rate: "$250.00", amt: "$750.00"   }
                        ]

                        // Header.
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.bottomMargin: 6
                            spacing: 8
                            Text { Layout.fillWidth: true; text: qsTr("Item"); color: Theme.mutedForeground; font.pixelSize: Theme.textXs; font.weight: Font.Medium }
                            Text { Layout.preferredWidth: invoiceTable.qtyW; horizontalAlignment: Text.AlignRight; text: qsTr("Qty"); color: Theme.mutedForeground; font.pixelSize: Theme.textXs; font.weight: Font.Medium }
                            Text { Layout.preferredWidth: invoiceTable.rateW; horizontalAlignment: Text.AlignRight; text: qsTr("Rate"); color: Theme.mutedForeground; font.pixelSize: Theme.textXs; font.weight: Font.Medium }
                            Text { Layout.preferredWidth: invoiceTable.amtW; horizontalAlignment: Text.AlignRight; text: qsTr("Amount"); color: Theme.mutedForeground; font.pixelSize: Theme.textXs; font.weight: Font.Medium }
                        }
                        Separator { Layout.fillWidth: true }

                        // Item rows.
                        Repeater {
                            model: invoiceTable._rows
                            delegate: RowLayout {
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.topMargin: 6
                                Layout.bottomMargin: 6
                                spacing: 8
                                Text { Layout.fillWidth: true; text: modelData.item; color: Theme.foreground; font.pixelSize: Theme.textSm; elide: Text.ElideRight }
                                Num { Layout.preferredWidth: invoiceTable.qtyW; text: modelData.qty }
                                Num { Layout.preferredWidth: invoiceTable.rateW; text: modelData.rate }
                                Num { Layout.preferredWidth: invoiceTable.amtW; text: modelData.amt }
                            }
                        }
                        Separator { Layout.fillWidth: true }

                        // Totals (colspan label right-aligned + amount).
                        component TotalRow: RowLayout {
                            property string label: ""
                            property string value: ""
                            Layout.fillWidth: true
                            Layout.topMargin: 6
                            spacing: 8
                            Text { Layout.fillWidth: true; horizontalAlignment: Text.AlignRight; text: label; color: Theme.mutedForeground; font.pixelSize: Theme.textSm }
                            Text { Layout.preferredWidth: invoiceTable.amtW; horizontalAlignment: Text.AlignRight; text: value; color: Theme.foreground; font.pixelSize: Theme.textSm; font.family: Theme.fontMono }
                        }
                        TotalRow { label: qsTr("Subtotal"); value: qsTr("$2,437.00") }
                        TotalRow { label: qsTr("Tax"); value: qsTr("$0.00") }
                        TotalRow { label: qsTr("Total Due"); value: qsTr("$2,437.00") }
                    }
                }
                CardFooter {
                    Button { text: qsTr("Download PDF"); variant: Button.Outline; size: Button.Sm }
                    Item { Layout.fillWidth: true }
                    Button { text: qsTr("Pay Now"); size: Button.Sm }
                }
            }
        }

        // ============================ Column 2 ============================
        // IconPreviewGrid · UIElements · ObservabilityCard · ShippingAddress
        ColumnLayout {
            Layout.preferredWidth: 360
            Layout.minimumWidth: 360
            Layout.maximumWidth: 360
            Layout.alignment: Qt.AlignTop
            spacing: 16

            // ---- Icon preview grid (8 columns, 16 ring-bordered chips) ----
            Card {
                Layout.fillWidth: true
                CardContent {
                    // 8 equal fractional columns (grid-cols-8 place-items-center):
                    // each cell fills 1/8 of the card width with a 32px ring chip
                    // centred in it, so the row never overflows the card.
                    GridLayout {
                        Layout.fillWidth: true
                        columns: 8
                        columnSpacing: 8
                        rowSpacing: 12
                        Repeater {
                            model: [
                                "copy", "circle-alert", "trash-2", "share-2",
                                "shopping-bag", "more-horizontal", "loader-circle", "plus",
                                "minus", "arrow-left", "arrow-right", "check",
                                "chevron-down", "chevron-right", "search", "settings"
                            ]
                            delegate: Item {
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.preferredHeight: 32
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 32; height: 32
                                    radius: Theme.radiusMd
                                    color: "transparent"
                                    border.width: 1
                                    border.color: Theme.border
                                    LucideIcon { anchors.centerIn: parent; name: modelData; size: 16; color: Theme.foreground }
                                }
                            }
                        }
                    }
                }
            }

            // ---- UI Elements (comprehensive component showcase) ----
            Card {
                Layout.fillWidth: true
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 22

                        // Buttons + two-factor item
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 14
                            Flow {
                                Layout.fillWidth: true
                                spacing: 8
                                Button { text: qsTr("Button") }
                                Button { text: qsTr("Secondary"); variant: Button.Secondary }
                                Button { text: qsTr("Outline"); variant: Button.Outline }
                                Button { text: qsTr("Ghost"); variant: Button.Ghost }
                            }
                            Rectangle {
                                Layout.fillWidth: true
                                radius: Theme.radiusLg
                                color: "transparent"
                                border.width: 1
                                border.color: Theme.border
                                implicitHeight: twoFa.implicitHeight + 24
                                RowLayout {
                                    id: twoFa
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.margins: 14
                                    spacing: 12
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 2
                                        Text { text: qsTr("Two-factor authentication"); color: Theme.foreground; font.pixelSize: Theme.textSm; font.weight: Font.Medium }
                                        Text { text: qsTr("Verify via email or phone number."); color: Theme.mutedForeground; font.pixelSize: Theme.textSm }
                                    }
                                    Button { text: qsTr("Enable"); variant: Button.Secondary; size: Button.Sm }
                                }
                            }
                        }

                        Slider { Layout.fillWidth: true; from: 0; to: 1000; value: 400; stepSize: 10 }

                        // Name input + message textarea
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            InputGroup {
                                Layout.fillWidth: true
                                InputGroupInput { placeholderText: qsTr("Name") }
                                InputGroupAddon {
                                    align: InputGroupAddon.InlineEnd
                                    LucideIcon { name: "search"; size: 14; color: Theme.mutedForeground }
                                }
                            }
                            Textarea { Layout.fillWidth: true; Layout.preferredHeight: 72; placeholderText: qsTr("Message") }
                        }

                        // Badges + radio + checkboxes
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8
                            Badge { text: qsTr("Badge") }
                            Badge { text: qsTr("Secondary"); variant: Badge.Secondary }
                            Badge { text: qsTr("Outline"); variant: Badge.Outline }
                            Item { Layout.fillWidth: true }
                            RowLayout {
                                spacing: 8
                                RadioButton { checked: true }
                                RadioButton {}
                            }
                            Checkbox { checked: true }
                            Checkbox {}
                        }

                        // Alert dialog + button group + switch
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            Button {
                                text: qsTr("Alert Dialog")
                                variant: Button.Outline
                                onClicked: uiElAlert.open()
                                AlertDialog {
                                    id: uiElAlert
                                    title: qsTr("Allow accessory to connect?")
                                    description: qsTr("Do you want to allow the USB accessory to connect to this device and your data?")
                                    cancelText: qsTr("Don't allow")
                                    actionText: qsTr("Allow")
                                }
                            }
                            ButtonGroup {
                                Button { variant: Button.Outline; text: qsTr("Button Group") }
                                Button {
                                    id: bgMore
                                    variant: Button.Outline
                                    size: Button.Icon
                                    iconName: "chevron-up"
                                    onClicked: bgMenu.popup(0, -bgMenu.height - 4)
                                    Menu {
                                        id: bgMenu
                                        MenuLabel { text: qsTr("Quick Actions") }
                                        MenuItem { text: qsTr("Mute Conversation") }
                                        MenuItem { text: qsTr("Mark as Read") }
                                        MenuItem { text: qsTr("Block User") }
                                        MenuSeparator {}
                                        MenuItem { text: qsTr("Share Conversation") }
                                    }
                                }
                            }
                            Item { Layout.fillWidth: true }
                            Switch { checked: true }
                        }
                    }
                }
            }

            // ---- Observability card (image banner + CTA) ----
            Card {
                Layout.fillWidth: true
                CardContent {
                    // aspect-video image banner; approximated with a primary-tinted
                    // muted panel + image glyph (no remote Unsplash asset).
                    edgeToEdge: true
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: width * 9 / 16
                        Layout.topMargin: -Theme.space6
                        Layout.bottomMargin: Theme.space2
                        color: Theme.alpha(Theme.muted, 0.6)
                        Rectangle { anchors.fill: parent; color: Theme.primary; opacity: 0.18 }
                        LucideIcon { anchors.centerIn: parent; name: "image"; size: 40; color: Theme.mutedForeground }
                    }
                }
                CardHeader {
                    CardTitle { text: qsTr("Observability Plus is replacing Monitoring") }
                    CardDescription {
                        text: qsTr("Switch to the improved way to explore your data, with natural "
                                 + "language. Monitoring will no longer be available on the Pro plan "
                                 + "in November, 2025")
                    }
                }
                CardFooter {
                    Button { text: qsTr("Create Query"); trailingIconName: "plus" }
                    Item { Layout.fillWidth: true }
                    Badge { variant: Badge.Secondary; text: qsTr("Warning") }
                }
            }

            // ---- Shipping address ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("Shipping Address") }
                    CardDescription { text: qsTr("Where should we deliver?") }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 14
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("Street address") }
                            Input { Layout.fillWidth: true; placeholderText: qsTr("123 Main Street") }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("Apt / Suite") }
                            Input { Layout.fillWidth: true; placeholderText: qsTr("Apt 4B") }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 6
                                Label { text: qsTr("City") }
                                Input { Layout.fillWidth: true; placeholderText: qsTr("San Francisco") }
                            }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 6
                                Label { text: qsTr("State") }
                                Select { Layout.fillWidth: true; model: [qsTr("California"), qsTr("New York"), qsTr("Texas")] }
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 6
                                Label { text: qsTr("ZIP Code") }
                                Input { Layout.fillWidth: true; placeholderText: qsTr("94102") }
                            }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 6
                                Label { text: qsTr("Country") }
                                Select { Layout.fillWidth: true; model: [qsTr("United States"), qsTr("Canada"), qsTr("United Kingdom")] }
                            }
                        }
                        Checkbox { checked: true; text: qsTr("Save as default address") }
                    }
                }
                CardFooter {
                    Button { text: qsTr("Cancel"); variant: Button.Outline; size: Button.Sm }
                    Item { Layout.fillWidth: true }
                    Button { text: qsTr("Save Address"); size: Button.Sm }
                }
            }
        }

        // ============================ Column 3 ============================
        // EnvironmentVariables · BarChartCard · InviteTeam · ActivateAgentDialog
        ColumnLayout {
            Layout.preferredWidth: 360
            Layout.minimumWidth: 360
            Layout.maximumWidth: 360
            Layout.alignment: Qt.AlignTop
            spacing: 16

            // ---- Environment variables ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("Environment Variables") }
                    CardDescription { text: qsTr("Production · 8 variables") }
                }
                CardContent {
                    ColumnLayout {
                        id: envList
                        Layout.fillWidth: true
                        spacing: 10
                        property var _rows: [
                            { key: "DATABASE_URL",    val: "••••••••", masked: true },
                            { key: "NEXT_PUBLIC_API",  val: "https://api.example.com", masked: false },
                            { key: "STRIPE_SECRET",    val: "••••••••", masked: true }
                        ]
                        Repeater {
                            model: envList._rows
                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                radius: Theme.radiusMd
                                color: "transparent"
                                border.width: 1
                                border.color: Theme.border
                                implicitHeight: envRow.implicitHeight + 16
                                RowLayout {
                                    id: envRow
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10
                                    spacing: 8
                                    Text {
                                        text: modelData.key
                                        color: Theme.foreground
                                        font.family: Theme.fontMono
                                        font.pixelSize: Theme.textXs
                                        font.weight: Font.Medium
                                    }
                                    Item { Layout.fillWidth: true }
                                    Text {
                                        text: modelData.val
                                        color: Theme.mutedForeground
                                        font.family: Theme.fontMono
                                        font.pixelSize: Theme.textXs
                                    }
                                }
                            }
                        }
                    }
                }
                CardFooter {
                    RowLayout {
                        Layout.fillWidth: true
                        Button { text: qsTr("Edit"); variant: Button.Outline }
                        Item { Layout.fillWidth: true }
                        Button { text: qsTr("Deploy") }
                    }
                }
            }

            // ---- Traffic channels (grouped bar) ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("Traffic channels"); font.pixelSize: Theme.textLg }
                    CardDescription {
                        Layout.fillWidth: true
                        text: qsTr("Monthly desktop and mobile traffic for the last six months—compare "
                                 + "volume and mix across platforms and devices at a glance.")
                        wrapMode: Text.Wrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                    }
                }
                CardContent {
                    Chart {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 150
                        type: Chart.Bar
                        categoryKey: "month"
                        barRadius: 6
                        showXAxis: true
                        showLegend: true
                        xTickFormatter: function (v) { return String(v).substring(0, 3) }
                        series: [
                            { key: "desktop", label: qsTr("Desktop"), color: Theme.chart1 },
                            { key: "mobile",  label: qsTr("Mobile"),  color: Theme.chart2 }
                        ]
                        chartData: [
                            { month: "January",  desktop: 186, mobile: 120 },
                            { month: "February", desktop: 245, mobile: 160 },
                            { month: "March",    desktop: 207, mobile: 140 },
                            { month: "April",    desktop: 260, mobile: 180 },
                            { month: "May",      desktop: 209, mobile: 130 },
                            { month: "June",     desktop: 214, mobile: 160 }
                        ]
                    }
                }
                CardContent {
                    // 3 stats divided by thin vertical rules (divide-x divide-border/60).
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        component StatCol: ColumnLayout {
                            id: sc
                            property string k: ""
                            property string v: ""
                            property color vColor: Theme.foreground
                            Layout.fillWidth: true
                            spacing: 2
                            Text { Layout.alignment: Qt.AlignHCenter; text: sc.k; color: Theme.mutedForeground; font.pixelSize: 10; font.weight: Font.Medium; font.letterSpacing: 0.4 }
                            Text { Layout.alignment: Qt.AlignHCenter; text: sc.v; color: sc.vColor; font.pixelSize: Theme.textSm; font.weight: Font.Medium }
                        }
                        component VRule: Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 30; color: Theme.alpha(Theme.border, 0.6) }
                        StatCol { k: qsTr("DESKTOP");   v: qsTr("1,224") }
                        VRule {}
                        StatCol { k: qsTr("MOBILE");    v: qsTr("860") }
                        VRule {}
                        StatCol { k: qsTr("MIX DELTA"); v: qsTr("+42%"); vColor: "#10b981" }
                    }
                }
                CardFooter {
                    Button { Layout.fillWidth: true; text: qsTr("View report") }
                }
            }

            // ---- Invite team ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("Invite Team") }
                    CardDescription { text: qsTr("Add members to your workspace") }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            Repeater {
                                model: [
                                    { email: "alex@example.com", role: 1 },
                                    { email: "sam@example.com",  role: 2 }
                                ]
                                delegate: RowLayout {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    spacing: 8
                                    Input { Layout.fillWidth: true; text: modelData.email }
                                    Select {
                                        Layout.preferredWidth: 96
                                        currentIndex: modelData.role
                                        model: [qsTr("Admin"), qsTr("Editor"), qsTr("Viewer")]
                                    }
                                }
                            }
                        }
                        Button {
                            Layout.fillWidth: true
                            variant: Button.Outline
                            iconName: "plus"
                            text: qsTr("Add another")
                        }
                        Separator { Layout.fillWidth: true }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("Or share invite link") }
                            InputGroup {
                                Layout.fillWidth: true
                                InputGroupInput { text: qsTr("https://app.co/invite/x8f2k"); readOnly: true }
                                InputGroupAddon {
                                    align: InputGroupAddon.InlineEnd
                                    LucideIcon { name: "copy"; size: 14; color: Theme.mutedForeground }
                                }
                            }
                        }
                    }
                }
                CardFooter {
                    Button { Layout.fillWidth: true; text: qsTr("Send Invites") }
                }
            }

            // ---- Activate agent dialog ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("Ship faster & safer with Vercel Agent") }
                    CardDescription {
                        text: qsTr("Your use is subject to Vercel's Public Beta Agreement and AI Product Terms.")
                    }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            component Feature: RowLayout {
                                property string body: ""
                                property bool showBadge: false
                                Layout.fillWidth: true
                                spacing: 8
                                LucideIcon { name: "circle-check-big"; size: 18; color: Theme.primary; Layout.alignment: Qt.AlignTop }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 6
                                    Text {
                                        Layout.fillWidth: true
                                        text: body
                                        color: Theme.mutedForeground
                                        font.pixelSize: Theme.textSm
                                        lineHeight: 1.45
                                        wrapMode: Text.Wrap
                                    }
                                    Badge { visible: showBadge; variant: Badge.Secondary; text: qsTr("Requires Observability Plus") }
                                }
                            }
                            Feature { body: qsTr("Code reviews with full codebase context to catch hard-to-find bugs.") }
                            Feature { body: qsTr("Code suggestions validated in sandboxes before you merge.") }
                            Feature { body: qsTr("Root-cause analysis for production issues with deployment context."); showBadge: true }
                        }
                        Alert {
                            Layout.fillWidth: true
                            description: qsTr("Pro teams get $100 in Vercel Agent trial credit for 2 weeks after activation.")
                        }
                    }
                }
                CardFooter {
                    Item { Layout.fillWidth: true }
                    Button { text: qsTr("Cancel"); variant: Button.Outline }
                    Button { text: qsTr("Enable with $100 credits") }
                }
            }
        }

        // ============================ Column 4 ============================
        // SkeletonLoading · PieChartCard · NoTeamMembers · ReportBug · Contributors
        ColumnLayout {
            Layout.preferredWidth: 360
            Layout.minimumWidth: 360
            Layout.maximumWidth: 360
            Layout.alignment: Qt.AlignTop
            spacing: 16

            // ---- Skeleton loading ----
            Card {
                Layout.fillWidth: true
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            Skeleton { Layout.preferredWidth: 40; Layout.preferredHeight: 40; radius: 20 }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 8
                                Skeleton { Layout.preferredWidth: parent.width * 0.75; Layout.preferredHeight: 16 }
                                Skeleton { Layout.preferredWidth: parent.width * 0.5; Layout.preferredHeight: 12 }
                            }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8
                            Skeleton { Layout.fillWidth: true; Layout.preferredHeight: 12 }
                            Skeleton { Layout.fillWidth: true; Layout.preferredHeight: 12 }
                            Skeleton { Layout.preferredWidth: parent.width * 0.8; Layout.preferredHeight: 12 }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8
                            Skeleton { Layout.preferredWidth: 80; Layout.preferredHeight: 32 }
                            Skeleton { Layout.preferredWidth: 80; Layout.preferredHeight: 32 }
                        }
                    }
                }
            }

            // ---- Browser share (donut with centre total) ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    RowLayout {
                        Layout.fillWidth: true
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            CardTitle { text: qsTr("Browser Share") }
                            CardDescription { text: qsTr("January - June 2026") }
                        }
                        Badge { variant: Badge.Outline; text: qsTr("Firefox"); Layout.alignment: Qt.AlignTop }
                    }
                }
                CardContent {
                    Chart {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 190
                        type: Chart.Pie
                        nameKey: "browser"
                        valueKey: "visitors"
                        innerRadius: 50
                        showLegend: true
                        hideTooltipLabel: true
                        centerText: (935).toLocaleString(Qt.locale("en_US"))
                        centerSubtext: qsTr("Visitors")
                        centerValueSize: Theme.text2xl
                        chartData: [
                            { browser: qsTr("Chrome"),  visitors: 275, color: Theme.chart1 },
                            { browser: qsTr("Safari"),  visitors: 200, color: Theme.chart2 },
                            { browser: qsTr("Firefox"), visitors: 287, color: Theme.chart3 },
                            { browser: qsTr("Edge"),    visitors: 173, color: Theme.chart4 }
                        ]
                    }
                }
                CardFooter {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: qsTr("Firefox"); color: Theme.foreground; font.pixelSize: Theme.textXs; font.weight: Font.Medium }
                            Item { Layout.fillWidth: true }
                            Text { text: qsTr("31%"); color: Theme.mutedForeground; font.pixelSize: Theme.textXs }
                        }
                        Progress { Layout.fillWidth: true; value: 31 }
                    }
                }
            }

            // ---- No team members (empty + avatar group) ----
            Card {
                Layout.fillWidth: true
                CardContent {
                    Empty {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 224          // h-56
                        border.width: 1
                        border.color: Theme.border
                        EmptyHeader {
                            EmptyMedia {
                                variant: EmptyMedia.Default
                                // Overlapping trio (== AvatarGroup).
                                Item {
                                    readonly property var people: [
                                        { src: "https://github.com/shadcn.png", fb: "CN" },
                                        { src: "https://github.com/maxleiter.png", fb: "LR" },
                                        { src: "https://github.com/evilrabbit.png", fb: "ER" }
                                    ]
                                    implicitHeight: 40
                                    implicitWidth: 40 + (people.length - 1) * 24
                                    Repeater {
                                        model: parent.people
                                        delegate: Rectangle {
                                            required property int index
                                            required property var modelData
                                            x: index * 24
                                            z: 10 - index
                                            width: 44; height: 44; radius: 22
                                            color: Theme.background
                                            Avatar {
                                                anchors.centerIn: parent
                                                size: Avatar.Lg
                                                source: modelData.src
                                                fallback: modelData.fb
                                            }
                                        }
                                    }
                                }
                            }
                            EmptyTitle { text: qsTr("No Team Members") }
                            EmptyDescription { text: qsTr("Invite your team to collaborate on this project.") }
                        }
                        EmptyContent {
                            Button { Layout.alignment: Qt.AlignHCenter; text: qsTr("Invite Members"); size: Button.Sm }
                        }
                    }
                }
            }

            // ---- Report bug ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("Report Bug") }
                    CardDescription { text: qsTr("Help us fix issues faster.") }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 14
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("Title") }
                            Input { Layout.fillWidth: true; placeholderText: qsTr("Brief description of the issue") }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 6
                                Label { text: qsTr("Severity") }
                                Select { Layout.fillWidth: true; currentIndex: 2; model: [qsTr("Critical"), qsTr("High"), qsTr("Medium"), qsTr("Low")] }
                            }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 6
                                Label { text: qsTr("Component") }
                                Select { Layout.fillWidth: true; model: [qsTr("Dashboard"), qsTr("Auth"), qsTr("API"), qsTr("Billing")] }
                            }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("Steps to reproduce") }
                            Textarea { Layout.fillWidth: true; Layout.preferredHeight: 96; placeholderText: qsTr("1. Go to\n2. Click on\n3. Observe...") }
                        }
                    }
                }
                CardFooter {
                    Item { Layout.fillWidth: true }
                    Button { text: qsTr("Attach File"); variant: Button.Outline }
                    Button { text: qsTr("Submit Bug") }
                }
            }

            // ---- Contributors (avatar wrap) ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        CardTitle { text: qsTr("Contributors") }
                        Badge { variant: Badge.Secondary; text: qsTr("312") }
                    }
                }
                CardContent {
                    Flow {
                        Layout.fillWidth: true
                        spacing: 8
                        Repeater {
                            model: [
                                "shadcn", "vercel", "nextjs", "tailwindlabs", "typescript-lang",
                                "eslint", "prettier", "babel", "webpack", "rollup", "parcel",
                                "vite", "react", "vue", "angular", "solid"
                            ]
                            delegate: Avatar {
                                required property var modelData
                                source: "https://github.com/" + modelData + ".png"
                                fallback: modelData.charAt(0).toUpperCase()
                            }
                        }
                    }
                }
                CardFooter {
                    Text {
                        text: qsTr("+ 810 contributors")
                        color: Theme.foreground
                        font.pixelSize: Theme.textSm
                        font.underline: true
                    }
                }
            }
        }

        // ============================ Column 5 ============================
        // FeedbackForm · BookAppointment · SleepReport · GithubProfile
        ColumnLayout {
            Layout.preferredWidth: 360
            Layout.minimumWidth: 360
            Layout.maximumWidth: 360
            Layout.alignment: Qt.AlignTop
            spacing: 16

            // ---- Feedback form ----
            Card {
                Layout.fillWidth: true
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 14
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("Topic") }
                            NativeSelect {
                                Layout.fillWidth: true
                                model: [
                                    qsTr("Select a topic"), qsTr("AI"), qsTr("Accounts and Access Controls"),
                                    qsTr("Billing"), qsTr("CDN (Firewall, Caching)"),
                                    qsTr("CI/CD (Builds, Deployments, Environment Variables)"),
                                    qsTr("Dashboard Interface (Navigation, UI Issues)"), qsTr("Domains"),
                                    qsTr("Frameworks"), qsTr("Marketplace and Integrations"),
                                    qsTr("Observability (Observability, Logs, Monitoring)"), qsTr("Storage")
                                ]
                            }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("Feedback") }
                            Textarea { Layout.fillWidth: true; Layout.preferredHeight: 90; placeholderText: qsTr("Your feedback helps us improve...") }
                        }
                    }
                }
                CardFooter {
                    Button { text: qsTr("Submit") }
                }
            }

            // ---- Book appointment ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("Book Appointment") }
                    CardDescription { text: qsTr("Dr. Sarah Chen · Cardiology") }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("Available on March 18, 2026") }
                            ToggleGroup {
                                Layout.fillWidth: true
                                ToggleGroupItem { value: "slot-0"; text: qsTr("9:00 AM"); checked: true }
                                ToggleGroupItem { value: "slot-1"; text: qsTr("10:30 AM") }
                                ToggleGroupItem { value: "slot-2"; text: qsTr("11:00 AM") }
                                ToggleGroupItem { value: "slot-3"; text: qsTr("1:30 PM") }
                            }
                        }
                        Alert {
                            Layout.fillWidth: true
                            title: qsTr("New patient?")
                            description: qsTr("Please arrive 15 minutes early.")
                        }
                    }
                }
                CardFooter {
                    Button { Layout.fillWidth: true; text: qsTr("Book Appointment") }
                }
            }

            // ---- Sleep report (stacked bar) ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("Sleep Report") }
                    CardDescription { text: qsTr("Last night · 7h 24m") }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        Chart {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 128
                            type: Chart.Bar
                            stacked: true
                            categoryKey: "hour"
                            barRadius: 2
                            showLegend: false
                            hideTooltipLabel: true
                            series: [
                                { key: "deep",  label: qsTr("Deep"),  color: Theme.chart1 },
                                { key: "light", label: qsTr("Light"), color: Theme.chart2 },
                                { key: "rem",   label: qsTr("REM"),   color: Theme.chart3 }
                            ]
                            chartData: [
                                { hour: "10pm", deep: 0,  light: 30, rem: 0 },
                                { hour: "11pm", deep: 20, light: 10, rem: 0 },
                                { hour: "12am", deep: 40, light: 0,  rem: 10 },
                                { hour: "1am",  deep: 30, light: 5,  rem: 15 },
                                { hour: "2am",  deep: 10, light: 20, rem: 30 },
                                { hour: "3am",  deep: 25, light: 10, rem: 20 },
                                { hour: "4am",  deep: 15, light: 25, rem: 10 },
                                { hour: "5am",  deep: 5,  light: 35, rem: 15 },
                                { hour: "6am",  deep: 0,  light: 20, rem: 25 }
                            ]
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8
                            component SleepStat: ColumnLayout {
                                property string v: ""
                                property string k: ""
                                Layout.fillWidth: true
                                spacing: 2
                                Text { Layout.alignment: Qt.AlignHCenter; text: v; color: Theme.foreground; font.pixelSize: Theme.textSm; font.weight: Font.Medium; font.family: Theme.fontMono }
                                Text { Layout.alignment: Qt.AlignHCenter; text: k; color: Theme.mutedForeground; font.pixelSize: Theme.textXs }
                            }
                            SleepStat { v: qsTr("2h 10m"); k: qsTr("Deep") }
                            SleepStat { v: qsTr("3h 48m"); k: qsTr("Light") }
                            SleepStat { v: qsTr("1h 26m"); k: qsTr("REM") }
                            SleepStat { v: qsTr("84");     k: qsTr("Score") }
                        }
                    }
                }
                CardFooter {
                    Badge { variant: Badge.Outline; text: qsTr("Good") }
                    Item { Layout.fillWidth: true }
                    Button { text: qsTr("Details"); variant: Button.Outline; size: Button.Sm }
                }
            }

            // ---- GitHub profile ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("Profile") }
                    CardDescription { text: qsTr("Manage your profile information.") }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("Name") }
                            Input { Layout.fillWidth: true; placeholderText: qsTr("shadcn") }
                            Muted {
                                Layout.fillWidth: true
                                text: qsTr("Your name may appear around GitHub where you contribute or are "
                                         + "mentioned. You can remove it at any time.")
                                font.pixelSize: Theme.textXs
                                wrapMode: Text.Wrap
                            }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("Public Email") }
                            NativeSelect { Layout.fillWidth: true; model: [qsTr("m@shadcn.com"), qsTr("m@gmail.com")] }
                            Muted {
                                Layout.fillWidth: true
                                text: qsTr("You can manage verified email addresses in your email settings.")
                                font.pixelSize: Theme.textXs
                                wrapMode: Text.Wrap
                            }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("Bio") }
                            Textarea { Layout.fillWidth: true; Layout.preferredHeight: 80; placeholderText: qsTr("Tell us a little bit about yourself") }
                            Muted {
                                Layout.fillWidth: true
                                text: qsTr("You can @mention other users and organizations to link to them.")
                                font.pixelSize: Theme.textXs
                                wrapMode: Text.Wrap
                            }
                        }
                    }
                }
                CardFooter {
                    Button { text: qsTr("Save Profile") }
                }
            }
        }

        // ============================ Column 6 ============================
        // WeeklyFitnessSummary · FileUpload · AnalyticsCard · UsageCard · Shortcuts
        ColumnLayout {
            Layout.preferredWidth: 360
            Layout.minimumWidth: 360
            Layout.maximumWidth: 360
            Layout.alignment: Qt.AlignTop
            spacing: 16

            // ---- Weekly fitness summary (per-day load bars) ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("Weekly Fitness Summary") }
                    CardDescription { text: qsTr("Calories and workout load by day") }
                }
                CardContent {
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Repeater {
                            model: [
                                { day: "M", load: 84 }, { day: "T", load: 52 }, { day: "W", load: 73 },
                                { day: "T", load: 66 }, { day: "F", load: 91 }, { day: "S", load: 48 },
                                { day: "S", load: 61 }
                            ]
                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                implicitHeight: dayCol.implicitHeight + 12
                                radius: Theme.radiusMd
                                color: "transparent"
                                border.width: 1
                                border.color: Theme.border
                                ColumnLayout {
                                    id: dayCol
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    spacing: 4
                                    Text { Layout.alignment: Qt.AlignHCenter; text: modelData.day; color: Theme.mutedForeground; font.pixelSize: Theme.textSm }
                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 64
                                        radius: Theme.radiusSm
                                        color: Theme.muted
                                        clip: true
                                        Rectangle {
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.bottom: parent.bottom
                                            height: parent.height * modelData.load / 100
                                            radius: Theme.radiusSm
                                            color: Theme.chart3
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                CardFooter {
                    Button { Layout.fillWidth: true; text: qsTr("View details") }
                }
            }

            // ---- File upload (empty + icon) ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("File Upload") }
                    CardDescription { text: qsTr("Drag and drop or browse") }
                }
                CardContent {
                    Empty {
                        Layout.fillWidth: true
                        border.width: 1
                        border.color: Theme.border
                        EmptyHeader {
                            EmptyMedia { variant: EmptyMedia.Icon; iconName: "cloud-upload" }
                            EmptyTitle { text: qsTr("Upload files") }
                            EmptyDescription { text: qsTr("PNG, JPG, PDF up to 10MB") }
                        }
                        EmptyContent {
                            Button { Layout.alignment: Qt.AlignHCenter; text: qsTr("Browse Files") }
                        }
                    }
                }
            }

            // ---- Analytics (area chart) ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    RowLayout {
                        Layout.fillWidth: true
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            CardTitle { text: qsTr("Analytics") }
                            RowLayout {
                                spacing: 8
                                Text { text: qsTr("418.2K Visitors"); color: Theme.mutedForeground; font.pixelSize: Theme.textSm }
                                Badge { text: qsTr("+10%") }
                            }
                        }
                        Button { text: qsTr("View Analytics"); variant: Button.Outline; size: Button.Sm; Layout.alignment: Qt.AlignTop }
                    }
                }
                CardContent {
                    edgeToEdge: true
                    Chart {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 120
                        type: Chart.Area
                        categoryKey: "month"
                        curved: false
                        areaFillOpacity: 0.4
                        showXAxis: false
                        showLegend: false
                        hideTooltipLabel: true
                        series: [ { key: "visitors", label: qsTr("Visitors"), color: Theme.chart1 } ]
                        chartData: [
                            { month: "January",  visitors: 186 },
                            { month: "February", visitors: 305 },
                            { month: "March",    visitors: 237 },
                            { month: "April",    visitors: 73 },
                            { month: "May",      visitors: 209 },
                            { month: "June",     visitors: 214 }
                        ]
                    }
                }
            }

            // ---- Usage card (circular gauges) ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("5 days remaining in cycle"); font.pixelSize: Theme.textSm }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 10
                        Repeater {
                            model: [
                                { name: qsTr("Edge Requests"),          value: "$1.83K",                  pct: 67.34 },
                                { name: qsTr("Fast Data Transfer"),     value: "$952.51",                 pct: 52.18 },
                                { name: qsTr("Monitoring data points"), value: "$901.20",                 pct: 89.42 },
                                { name: qsTr("Web Analytics Events"),   value: "$603.71",                 pct: 45.67 },
                                { name: qsTr("ISR Writes"),             value: "524.52K / 2M",            pct: 26.23 },
                                { name: qsTr("Function Duration"),      value: "5.11 GB Hrs / 1K GB Hrs", pct: 5.11 }
                            ]
                            delegate: RowLayout {
                                required property var modelData
                                Layout.fillWidth: true
                                spacing: 10
                                CircleGauge { percentage: modelData.pct; Layout.alignment: Qt.AlignVCenter }
                                Text { Layout.fillWidth: true; text: modelData.name; color: Theme.foreground; font.pixelSize: Theme.textSm; elide: Text.ElideRight }
                                Text { text: modelData.value; color: Theme.mutedForeground; font.pixelSize: Theme.textXs; font.family: Theme.fontMono }
                            }
                        }
                    }
                }
            }

            // ---- Shortcuts ----
            Card {
                Layout.fillWidth: true
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        Text { text: qsTr("Shortcuts"); color: Theme.foreground; font.pixelSize: Theme.textSm; font.weight: Font.Medium }
                        Repeater {
                            model: [
                                { label: qsTr("Search"),         keys: ["⌘", "K"] },
                                { label: qsTr("Quick Actions"),  keys: ["⌘", "J"] },
                                { label: qsTr("New File"),       keys: ["⌘", "N"] },
                                { label: qsTr("Save"),           keys: ["⌘", "S"] },
                                { label: qsTr("Toggle Sidebar"), keys: ["⌘", "B"] }
                            ]
                            delegate: ColumnLayout {
                                required property int index
                                required property var modelData
                                Layout.fillWidth: true
                                spacing: 8
                                Separator { Layout.fillWidth: true; visible: index > 0 }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { Layout.fillWidth: true; text: modelData.label; color: Theme.mutedForeground; font.pixelSize: Theme.textSm }
                                    KbdGroup {
                                        Repeater {
                                            model: modelData.keys
                                            delegate: Kbd { required property var modelData; text: modelData }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // ============================ Column 7 ============================
        // AnomalyAlert · LiveWaveformCard · Visitors · ContributionsActivity · NotFound
        ColumnLayout {
            Layout.preferredWidth: 360
            Layout.minimumWidth: 360
            Layout.maximumWidth: 360
            Layout.alignment: Qt.AlignTop
            spacing: 16

            // ---- Anomaly alert (empty) ----
            Card {
                Layout.fillWidth: true
                CardContent {
                    Empty {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 192           // h-48
                        EmptyHeader {
                            EmptyTitle { text: qsTr("Get alerted for anomalies") }
                            EmptyDescription { text: qsTr("Automatically monitor your projects for anomalies and get notified.") }
                        }
                        EmptyContent {
                            Button { Layout.alignment: Qt.AlignHCenter; text: qsTr("Upgrade to Observability Plus") }
                        }
                    }
                }
            }

            // ---- Live audio waveform (static approximation) ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("Live Audio Waveform") }
                    CardDescription { text: qsTr("Real-time microphone input visualization with audio reactivity") }
                }
                CardContent {
                    // Static center-weighted bar field (== <LiveWaveform> canvas, sampled once).
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                        spacing: 2
                        Repeater {
                            model: 48
                            delegate: Rectangle {
                                required property int index
                                readonly property real _v: {
                                    var c = 24
                                    var norm = (index - c) / c
                                    var w = 1 - Math.abs(norm) * 0.4
                                    var val = (0.22 + Math.sin(index * 0.5) * 0.16 + Math.cos(index * 0.3) * 0.1) * w
                                    return Math.max(0.08, Math.min(1, val))
                                }
                                Layout.preferredWidth: 3
                                Layout.preferredHeight: Math.max(4, _v * 64)
                                Layout.alignment: Qt.AlignVCenter
                                radius: 1.5
                                color: Theme.alpha(Theme.mutedForeground, 0.4 + _v * 0.5)
                            }
                        }
                    }
                }
                CardFooter {
                    Button { text: qsTr("Start Listening"); variant: Button.Outline; size: Button.Sm }
                    Button { text: qsTr("Stop Processing"); size: Button.Sm }
                    Button { text: qsTr("Static"); variant: Button.Outline; size: Button.Sm }
                }
            }

            // ---- Visitors (natural area chart) ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    RowLayout {
                        Layout.fillWidth: true
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            CardTitle { text: qsTr("Visitors") }
                            CardDescription { text: qsTr("Last 6 months") }
                        }
                        Badge { variant: Badge.Secondary; text: qsTr("+2% vs last month"); Layout.alignment: Qt.AlignTop }
                    }
                }
                CardContent {
                    edgeToEdge: true
                    Chart {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 192            // h-48
                        type: Chart.Area
                        categoryKey: "month"
                        curved: true
                        areaFillOpacity: 0.15
                        showXAxis: false
                        showLegend: false
                        series: [ { key: "desktop", label: qsTr("Desktop"), color: Theme.chart1 } ]
                        chartData: [
                            { month: "January",  desktop: 186 },
                            { month: "February", desktop: 305 },
                            { month: "March",    desktop: 237 },
                            { month: "April",    desktop: 73 },
                            { month: "May",      desktop: 209 },
                            { month: "June",     desktop: 214 }
                        ]
                    }
                }
            }

            // ---- Contributions & activity ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("Contributions & Activity") }
                    CardDescription { text: qsTr("Manage your contributions and activity visibility.") }
                }
                CardContent {
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        Checkbox { Layout.alignment: Qt.AlignTop }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("Make profile private and hide activity") }
                            Muted {
                                Layout.fillWidth: true
                                text: qsTr("Enabling this will hide your contributions and activity from your "
                                         + "GitHub profile and from social features like followers, stars, "
                                         + "feeds, leaderboards and releases.")
                                font.pixelSize: Theme.textXs
                                wrapMode: Text.Wrap
                            }
                        }
                    }
                }
                CardFooter {
                    Button { text: qsTr("Save Changes") }
                }
            }

            // ---- 404 not found (empty + search) ----
            Card {
                Layout.fillWidth: true
                CardContent {
                    Empty {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 288           // h-72
                        EmptyHeader {
                            EmptyTitle { text: qsTr("404 - Not Found") }
                            EmptyDescription {
                                text: qsTr("The page you're looking for doesn't exist. Try searching for "
                                         + "what you need below.")
                            }
                        }
                        EmptyContent {
                            InputGroup {
                                Layout.preferredWidth: parent ? parent.width * 0.75 : 200
                                Layout.alignment: Qt.AlignHCenter
                                InputGroupAddon {
                                    LucideIcon { name: "search"; size: 14; color: Theme.mutedForeground }
                                }
                                InputGroupInput { placeholderText: qsTr("Try searching for pages...") }
                                InputGroupAddon {
                                    align: InputGroupAddon.InlineEnd
                                    Kbd { text: qsTr("/") }
                                }
                            }
                            Button { Layout.alignment: Qt.AlignHCenter; variant: Button.Link; text: qsTr("Go to homepage") }
                        }
                    }
                }
            }
        }

        Item { Layout.preferredWidth: 8 }   // Trailing whitespace
    }
}
