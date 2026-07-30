import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// Live-preview dashboard for the Create page — a 1:1 QML port of shadcn's
// registry `preview-02` bento block (apps/v4/registry/bases/base/blocks/
// preview-02). A horizontally-scrolling 6-column grid of ~35 finance/app cards
// that all re-theme through the Theme override layer. Column order and per-card
// content mirror index.tsx (and each cards/*.tsx) as closely as the base
// component set allows; missing primitives (QR code, sync spinner, video feed,
// sparklines) are approximated faithfully with Canvas / Repeater.
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

    // Muted rounded row == <Item variant="muted"> laid out horizontally.
    component MutedRow: Rectangle {
        default property alias rowData: rl.data
        property int pad: 12
        Layout.fillWidth: true
        radius: Theme.radiusMd
        color: Theme.alpha(Theme.muted, 0.5)
        implicitHeight: rl.implicitHeight + pad * 2
        RowLayout {
            id: rl
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: parent.pad
            anchors.rightMargin: parent.pad
            spacing: 12
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

    // Label (muted, fillWidth) + right-aligned value row (== flex justify-between).
    component InfoRow: RowLayout {
        id: ir
        property string label: ""
        property string value: ""
        property color valueColor: Theme.foreground
        property int valueWeight: Font.Medium
        Layout.fillWidth: true
        Text { Layout.fillWidth: true; text: ir.label; color: Theme.mutedForeground; font.pixelSize: Theme.textSm }
        Text { text: ir.value; color: ir.valueColor; font.pixelSize: Theme.textSm; font.weight: ir.valueWeight; font.family: Theme.fontMono }
    }

    // Bordered slider row (== KitchenIsland <Item variant="outline"> with icon + slider).
    component SliderRow: Rectangle {
        id: sr
        property string icon: ""
        property string label: ""
        property real value: 50
        Layout.fillWidth: true
        implicitHeight: 46
        radius: Theme.radiusMd
        color: "transparent"
        border.width: 1
        border.color: Theme.border
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            spacing: 12
            LucideIcon { name: sr.icon; size: 16; color: Theme.mutedForeground }
            Text { text: sr.label; color: Theme.foreground; font.pixelSize: Theme.textSm; Layout.preferredWidth: 74 }
            Slider { Layout.fillWidth: true; from: 0; to: 100; value: sr.value }
        }
    }

    // Sidebar-style nav card (== SidebarNav panel; the real Sidebar is too wide
    // for the nested half-column, so grouped menu rows are drawn with primitives).
    component SideNavCard: Card {
        id: navRoot
        property var groups: []
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignTop
        CardContent {
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                Repeater {
                    model: navRoot.groups
                    delegate: ColumnLayout {
                        required property var modelData
                        Layout.fillWidth: true
                        spacing: 2
                        Text {
                            text: modelData.label
                            color: Theme.mutedForeground
                            font.pixelSize: Theme.textXs
                            font.weight: Font.Medium
                            Layout.bottomMargin: 2
                        }
                        Repeater {
                            model: modelData.items
                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                implicitHeight: 30
                                radius: Theme.radiusMd
                                color: modelData.active ? Theme.alpha(Theme.muted, 0.7) : "transparent"
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 8
                                    anchors.rightMargin: 8
                                    spacing: 8
                                    LucideIcon { name: modelData.icon; size: 16; color: Theme.foreground }
                                    Text {
                                        Layout.fillWidth: true
                                        text: modelData.text
                                        color: Theme.foreground
                                        font.pixelSize: Theme.textSm
                                        font.weight: modelData.active ? Font.Medium : Font.Normal
                                        elide: Text.ElideRight
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // QR code approximation (== react-qr-code): finder patterns in 3 corners plus
    // a deterministic pseudo-random module field, painted black on white.
    component QrCode: Canvas {
        id: qr
        property int modules: 25
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            var m = modules
            var cell = width / m
            // White field.
            ctx.fillStyle = "#ffffff"
            ctx.fillRect(0, 0, width, height)
            ctx.fillStyle = "#000000"
            function rnd(i, j) { var x = Math.sin(i * 928.31 + j * 137.13) * 43758.5453; return (x - Math.floor(x)) > 0.55 }
            for (var i = 0; i < m; i++)
                for (var j = 0; j < m; j++) {
                    var inFinder = (i < 8 && j < 8) || (i < 8 && j > m - 9) || (i > m - 9 && j < 8)
                    if (inFinder) continue
                    if (rnd(i, j)) ctx.fillRect(Math.floor(i * cell), Math.floor(j * cell), Math.ceil(cell), Math.ceil(cell))
                }
            function finder(ox, oy) {
                ctx.fillStyle = "#000000"
                ctx.fillRect(ox * cell, oy * cell, 7 * cell, 7 * cell)
                ctx.fillStyle = "#ffffff"
                ctx.fillRect((ox + 1) * cell, (oy + 1) * cell, 5 * cell, 5 * cell)
                ctx.fillStyle = "#000000"
                ctx.fillRect((ox + 2) * cell, (oy + 2) * cell, 3 * cell, 3 * cell)
            }
            finder(0, 0); finder(0, m - 7); finder(m - 7, 0)
        }
        Component.onCompleted: requestPaint()
        onWidthChanged: requestPaint()
    }

    // Diagonal hatch fill (== FrontDoor repeating-linear-gradient video placeholder).
    component DiagonalHatch: Canvas {
        id: hatch
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.strokeStyle = Theme.border
            ctx.lineWidth = 1
            var step = 11
            for (var x = -height; x < width; x += step) {
                ctx.beginPath()
                ctx.moveTo(x, 0)
                ctx.lineTo(x + height, height)
                ctx.stroke()
            }
        }
        Component.onCompleted: requestPaint()
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
    }

    RowLayout {
        id: bento
        spacing: 16

        // ============================ Column 1 ============================
        // ContributionHistory · EmptyDistributeTrack · QrConnect · DividendIncome
        // · IndexInvesting · SyncingState
        ColumnLayout {
            Layout.preferredWidth: 360
            Layout.minimumWidth: 360
            Layout.maximumWidth: 360
            Layout.alignment: Qt.AlignTop
            spacing: 16

            // ---- Contribution History ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("Contribution History") }
                    CardDescription { text: qsTr("Last 6 months of activity") }
                }
                CardContent {
                    Chart {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 200
                        type: Chart.Bar
                        categoryKey: "month"
                        barRadius: 6
                        showXAxis: true
                        hideTooltipLabel: true
                        tooltipCursor: false
                        series: [ { key: "amount", label: qsTr("Contribution"), color: Theme.chart2 } ]
                        chartData: [
                            { month: "Dec", amount: 800 },
                            { month: "Jan", amount: 1100 },
                            { month: "Feb", amount: 900 },
                            { month: "Mar", amount: 1300 },
                            { month: "Apr", amount: 750 },
                            { month: "May", amount: 1400 }
                        ]
                    }
                }
                CardContent {
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        MutedBox {
                            Kicker { text: qsTr("UPCOMING") }
                            Stat { text: qsTr("May 25, 2024"); font.pixelSize: Theme.textLg }
                            Muted { text: qsTr("$1,000 scheduled") }
                        }
                        MutedBox {
                            Kicker { text: qsTr("AUTO-SAVE PLAN") }
                            Stat { text: qsTr("Accelerated"); font.pixelSize: Theme.textLg }
                            Muted { text: qsTr("Recurring weekly") }
                        }
                    }
                }
                CardFooter {
                    Button { Layout.fillWidth: true; text: qsTr("View Full Report") }
                }
            }

            // ---- Empty: Distribute Track ----
            Card {
                Layout.fillWidth: true
                CardContent {
                    Empty {
                        Layout.fillWidth: true
                        EmptyHeader {
                            EmptyMedia { variant: EmptyMedia.Icon; iconName: "plus" }
                            EmptyTitle { text: qsTr("Distribute Track") }
                            EmptyDescription {
                                text: qsTr("Upload your first master to start reaching listeners on Spotify, Apple Music, and more.")
                            }
                        }
                        EmptyContent {
                            Button { Layout.alignment: Qt.AlignHCenter; text: qsTr("Create Release") }
                        }
                    }
                }
            }

            // ---- QR Connect ----
            Card {
                Layout.fillWidth: true
                CardContent {
                    // rounded-xl border bg-white p-4 with the QR centered.
                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 6
                        implicitWidth: 192
                        implicitHeight: 192
                        radius: Theme.radiusXl
                        color: "#ffffff"
                        border.width: 1
                        border.color: Theme.border
                        QrCode { anchors.centerIn: parent; width: 160; height: 160 }
                    }
                }
                CardHeader {
                    CardTitle { Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; text: qsTr("Scan to connect your mobile device") }
                    CardDescription { Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; text: qsTr("Open the Ledger mobile app and scan this code to link your device.") }
                }
                CardFooter {
                    Button { Layout.fillWidth: true; text: qsTr("Got it"); variant: Button.Secondary }
                }
            }

            // ---- Q2 Dividend Income (holdings + sparklines) ----
            Card {
                Layout.fillWidth: true
                RowLayout {
                    Layout.fillWidth: true
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        CardTitle { text: qsTr("Q2 Dividend Income") }
                        CardDescription {
                            Layout.fillWidth: true
                            text: qsTr("Quarterly dividend payouts across your portfolio holdings.")
                            wrapMode: Text.Wrap
                        }
                    }
                    IconButton { iconName: "x"; variant: IconButton.Ghost; size: IconButton.Small; Layout.alignment: Qt.AlignTop }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        Repeater {
                            model: [
                                { name: "Vanguard VIG", shares: "450 Shares", amount: "$1,842.10", data: [{ q: "Q1", v: 380 }, { q: "Q2", v: 420 }, { q: "Q3", v: 390 }, { q: "Q4", v: 652 }] },
                                { name: "S&P 500 VOO", shares: "112 Shares", amount: "$928.40", data: [{ q: "Q1", v: 180 }, { q: "Q2", v: 210 }, { q: "Q3", v: 320 }, { q: "Q4", v: 218 }] },
                                { name: "Apple AAPL", shares: "85 Shares", amount: "$340.00", data: [{ q: "Q1", v: 60 }, { q: "Q2", v: 70 }, { q: "Q3", v: 120 }, { q: "Q4", v: 90 }] },
                                { name: "Realty Income", shares: "320 Shares", amount: "$1,139.50", data: [{ q: "Q1", v: 240 }, { q: "Q2", v: 260 }, { q: "Q3", v: 280 }, { q: "Q4", v: 360 }] }
                            ]
                            delegate: MutedRow {
                                required property var modelData
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 0
                                    Text { text: modelData.name; color: Theme.foreground; font.pixelSize: Theme.textSm; font.weight: Font.Medium }
                                    Text { text: modelData.shares; color: Theme.mutedForeground; font.pixelSize: Theme.textXs }
                                }
                                Chart {
                                    Layout.preferredWidth: 88
                                    Layout.preferredHeight: 32
                                    type: Chart.Bar
                                    categoryKey: "q"
                                    barRadius: 3
                                    showXAxis: false
                                    hideTooltipLabel: true
                                    tooltipCursor: false
                                    series: [ { key: "v", label: qsTr("Dividend"), color: Theme.chart2 } ]
                                    chartData: modelData.data
                                }
                                Text { text: modelData.amount; color: Theme.foreground; font.pixelSize: Theme.textSm; font.weight: Font.DemiBold; font.family: Theme.fontMono }
                            }
                        }
                    }
                }
            }

            // ---- Dollar-Cost Averaging (index investing prose) ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("Dollar-Cost Averaging") }
                    CardDescription { text: qsTr("A strategy for building wealth over time.") }
                }
                CardContent {
                    Text {
                        Layout.fillWidth: true
                        text: qsTr("Over time, this smooths out the average cost of your investments. When prices drop, your fixed amount buys more shares. When prices rise, you buy fewer. The result is a lower average cost per share compared to lump-sum investing during volatile periods.")
                        color: Theme.mutedForeground
                        font.pixelSize: Theme.textSm
                        lineHeight: 1.5
                        wrapMode: Text.Wrap
                    }
                }
            }

            // ---- Syncing State (spinner empty state) ----
            Card {
                Layout.fillWidth: true
                CardContent {
                    Empty {
                        Layout.fillWidth: true
                        EmptyHeader {
                            EmptyMedia { variant: EmptyMedia.Icon; Spinner { size: 16 } }
                            EmptyTitle { text: qsTr("Syncing your accounts") }
                            EmptyDescription {
                                text: qsTr("We're pulling in your latest transactions. This usually takes a few seconds.")
                            }
                        }
                        EmptyContent {
                            Button { Layout.alignment: Qt.AlignHCenter; text: qsTr("Cancel"); variant: Button.Outline }
                        }
                    }
                }
            }
        }

        // ============================ Column 2 ============================
        // PayoutThreshold · ClaimableBalance · Preferences · SavingsProgress
        // · KitchenIsland
        ColumnLayout {
            Layout.preferredWidth: 360
            Layout.minimumWidth: 360
            Layout.maximumWidth: 360
            Layout.alignment: Qt.AlignTop
            spacing: 16

            // ---- Payout Threshold ----
            Card {
                Layout.fillWidth: true
                RowLayout {
                    Layout.fillWidth: true
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        CardTitle { text: qsTr("Payout Threshold") }
                        CardDescription { text: qsTr("Set the minimum balance required before a payout is triggered.") }
                    }
                    IconButton { iconName: "x"; variant: IconButton.Ghost; size: IconButton.Small; Layout.alignment: Qt.AlignTop }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 14

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("Preferred Currency") }
                            Select {
                                Layout.fillWidth: true
                                model: ["USD — United States Dollar", "EUR — Euro", "GBP — British Pound", "JPY — Japanese Yen"]
                            }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            RowLayout {
                                Layout.fillWidth: true
                                Label { Layout.fillWidth: true; text: qsTr("Minimum Payout Amount") }
                                Stat { text: qsTr("$2500.00"); font.pixelSize: Theme.textXl }
                            }
                            Slider { Layout.fillWidth: true; from: 50; to: 10000; value: 2500; stepSize: 50 }
                            RowLayout {
                                Layout.fillWidth: true
                                Muted { Layout.fillWidth: true; text: qsTr("$50 (MIN)"); font.pixelSize: Theme.textXs }
                                Muted { text: qsTr("$10,000 (MAX)"); font.pixelSize: Theme.textXs }
                            }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("Notes") }
                            Textarea { Layout.fillWidth: true; Layout.preferredHeight: 90; placeholderText: qsTr("Add any notes for this payout configuration...") }
                        }
                    }
                }
                CardFooter {
                    Button { Layout.fillWidth: true; text: qsTr("Save Threshold") }
                }
            }

            // ---- Claimable Balance ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardDescription { text: qsTr("Claimable Balance") }
                    CardTitle { text: qsTr("$0.00"); font.pixelSize: 40 }
                    Badge {
                        variant: Badge.Outline
                        text: qsTr("Pending Setup")
                        leading: Rectangle { width: 8; height: 8; radius: 4; color: "#eab308" }
                    }
                }
                CardContent {
                    MutedBox {
                        InfoRow { label: qsTr("Net Royalties"); value: qsTr("$0.00") }
                        InfoRow { label: qsTr("Processing Fee"); value: qsTr("-$0.00") }
                        Separator { Layout.fillWidth: true }
                        InfoRow { label: qsTr("Total Ready to Claim"); value: qsTr("$0.00 USD"); valueWeight: Font.DemiBold }
                    }
                }
                CardFooter {
                    CardDescription { Layout.fillWidth: true; text: qsTr("Once your bank is connected, balances over $10.00 are automatically eligible for monthly distribution on the 15th of each month.") }
                }
            }

            // ---- Preferences ----
            Card {
                Layout.fillWidth: true
                RowLayout {
                    Layout.fillWidth: true
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        CardTitle { text: qsTr("Preferences") }
                        CardDescription { text: qsTr("Manage your account settings and notifications.") }
                    }
                    IconButton { iconName: "x"; variant: IconButton.Ghost; size: IconButton.Small; Layout.alignment: Qt.AlignTop }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("Default Currency") }
                            Select {
                                Layout.fillWidth: true
                                model: ["USD — United States Dollar", "EUR — Euro", "GBP — British Pound", "JPY — Japanese Yen"]
                            }
                        }
                        Separator { Layout.fillWidth: true }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                Label { text: qsTr("Public Statistics") }
                                Muted { Layout.fillWidth: true; text: qsTr("Allow others to see your total stream count and listening activity"); font.pixelSize: Theme.textXs; wrapMode: Text.Wrap }
                            }
                            Switch { checked: true; Layout.alignment: Qt.AlignVCenter }
                        }
                        Separator { Layout.fillWidth: true }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                Label { text: qsTr("Email Notifications") }
                                Muted { Layout.fillWidth: true; text: qsTr("Monthly royalty reports and distribution updates"); font.pixelSize: Theme.textXs; wrapMode: Text.Wrap }
                            }
                            Switch { checked: true; Layout.alignment: Qt.AlignVCenter }
                        }
                    }
                }
                CardFooter {
                    Button { text: qsTr("Reset"); variant: Button.Outline }
                    Item { Layout.fillWidth: true }
                    Button { text: qsTr("Save Preferences") }
                }
            }

            // ---- Savings Progress (donut with center total) ----
            Card {
                Layout.fillWidth: true
                CardContent {
                    Chart {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 220
                        type: Chart.Pie
                        nameKey: "name"
                        valueKey: "value"
                        innerRadius: 66
                        hideTooltipLabel: true
                        centerText: qsTr("$24,000")
                        centerSubtext: qsTr("80% of $30,000")
                        centerValueSize: Theme.text2xl
                        chartData: [
                            { name: qsTr("Saved"), value: 24000, color: Theme.chart2 },
                            { name: qsTr("Remaining"), value: 6000, color: Theme.chart1 }
                        ]
                    }
                }
                CardFooter {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        InfoRow { label: qsTr("Projected Finish"); value: qsTr("October 2024"); valueWeight: Font.DemiBold }
                        Separator { Layout.fillWidth: true; Layout.topMargin: 10; Layout.bottomMargin: 10 }
                        InfoRow { label: qsTr("Monthly Average"); value: qsTr("$1,250"); valueWeight: Font.DemiBold }
                        Separator { Layout.fillWidth: true; Layout.topMargin: 10; Layout.bottomMargin: 10 }
                        InfoRow { label: qsTr("Top Contributor"); value: qsTr("Auto-Transfer"); valueWeight: Font.DemiBold }
                    }
                }
            }

            // ---- Kitchen Island (scenes + sliders) ----
            Card {
                Layout.fillWidth: true
                RowLayout {
                    Layout.fillWidth: true
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        CardTitle { text: qsTr("Kitchen Island") }
                        CardDescription { text: qsTr("Hue Color Ambient") }
                    }
                    Switch { checked: true; Layout.alignment: Qt.AlignVCenter }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        ToggleGroup {
                            Layout.fillWidth: true
                            variant: ToggleGroup.Outline
                            spacing: 1
                            ToggleGroupItem { value: "cooking"; text: qsTr("Cooking"); checked: true }
                            ToggleGroupItem { value: "dining"; text: qsTr("Dining") }
                            ToggleGroupItem { value: "nightlight"; text: qsTr("Nightlight") }
                            ToggleGroupItem { value: "focus"; text: qsTr("Focus") }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8
                            SliderRow { icon: "sun"; label: qsTr("Brightness"); value: 90 }
                            SliderRow { icon: "thermometer"; label: qsTr("Color Temp"); value: 70 }
                            SliderRow { icon: "volume-2"; label: qsTr("Volume"); value: 30 }
                            SliderRow { icon: "timer"; label: qsTr("Fade"); value: 0 }
                        }
                    }
                }
            }
        }

        // ============================ Column 3 (wide, col-span-2) ============================
        // SavingsTargets (Savings Targets + Buy Investment) · RecentTransactions
        // · [SidebarNav + Faq | Payments + FrontDoor] · ReleaseCatalog
        ColumnLayout {
            Layout.preferredWidth: 736
            Layout.minimumWidth: 736
            Layout.maximumWidth: 736
            Layout.alignment: Qt.AlignTop
            spacing: 16

            // ---- Savings Targets + Buy Investment (savings-targets.tsx 2-col grid) ----
            RowLayout {
                Layout.fillWidth: true
                spacing: 16

                Card {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    RowLayout {
                        Layout.fillWidth: true
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            CardTitle { text: qsTr("Savings Targets") }
                            CardDescription { text: qsTr("Active milestones for 2024") }
                        }
                        Button { text: qsTr("New Goal"); variant: Button.Outline; size: Button.Sm; Layout.alignment: Qt.AlignTop }
                    }
                    CardContent {
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            MutedBox {
                                Kicker { text: qsTr("RETIREMENT") }
                                Stat { text: qsTr("$420,000"); font.pixelSize: 28 }
                                Progress { Layout.fillWidth: true; value: 65 }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Muted { Layout.fillWidth: true; text: qsTr("65% achieved") }
                                    Stat { text: qsTr("$273,000"); font.pixelSize: Theme.textSm; font.weight: Font.Medium }
                                }
                            }
                            MutedBox {
                                Kicker { text: qsTr("REAL ESTATE") }
                                Stat { text: qsTr("$85,000"); font.pixelSize: 28 }
                                Progress { Layout.fillWidth: true; value: 32 }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Muted { Layout.fillWidth: true; text: qsTr("32% achieved") }
                                    Stat { text: qsTr("$27,200"); font.pixelSize: Theme.textSm; font.weight: Font.Medium }
                                }
                            }
                        }
                    }
                    CardFooter {
                        CardDescription { Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; text: qsTr("You have not met your targets for this year.") }
                    }
                }

                Card {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    CardHeader {
                        CardTitle { text: qsTr("Buy Investment") }
                    }
                    CardContent {
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 6
                                Label { text: qsTr("Amount to Invest") }
                                InputGroup {
                                    Layout.fillWidth: true
                                    InputGroupAddon { InputGroupText { text: qsTr("$") } }
                                    InputGroupInput { text: qsTr("1,000.00") }
                                }
                            }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 6
                                Label { text: qsTr("Order Type") }
                                NativeSelect { Layout.fillWidth: true; model: ["Market Order", "Limit Order", "Stop Order"] }
                                Muted { text: qsTr("Market orders execute at the current price."); font.pixelSize: Theme.textXs }
                            }
                            InfoRow { label: qsTr("Estimated Shares"); value: qsTr("1.95"); valueWeight: Font.DemiBold }
                            InfoRow { label: qsTr("Buying Power"); value: qsTr("$12,450.00"); valueWeight: Font.DemiBold }
                        }
                    }
                    CardFooter {
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            Button { Layout.fillWidth: true; text: qsTr("Review Order") }
                            CardDescription { Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; text: qsTr("Trades are typically executed within minutes during market hours.") }
                        }
                    }
                }
            }

            // ---- Recent Transactions ----
            Card {
                Layout.fillWidth: true
                RowLayout {
                    Layout.fillWidth: true
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        CardTitle { text: qsTr("Recent Transactions") }
                        CardDescription { text: qsTr("Your latest account activity.") }
                    }
                    Button { text: qsTr("View All"); variant: Button.Outline; size: Button.Sm; Layout.alignment: Qt.AlignTop }
                }
                CardContent {
                    ColumnLayout {
                        id: txList
                        Layout.fillWidth: true
                        spacing: 0
                        property var _tx: [
                            { icon: "coffee",        name: "Blue Bottle Coffee",   cat: "Food & Drink",   when: "Today, 10:24 AM", amt: "-$6.50",     pos: false },
                            { icon: "shopping-cart", name: "Whole Foods Market",   cat: "Groceries",      when: "Yesterday",       amt: "-$142.30",   pos: false },
                            { icon: "wallet",        name: "Stripe Payout",        cat: "Income",         when: "Oct 12",          amt: "+$4,200.00", pos: true  },
                            { icon: "car",           name: "Uber Technologies",    cat: "Transport",      when: "Oct 11",          amt: "-$24.10",    pos: false },
                            { icon: "tv",            name: "Netflix Subscription", cat: "Entertainment",  when: "Oct 10",          amt: "-$19.99",    pos: false }
                        ]
                        Repeater {
                            model: txList._tx
                            delegate: RowLayout {
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.topMargin: 6
                                Layout.bottomMargin: 6
                                spacing: 12
                                Rectangle {
                                    implicitWidth: 40; implicitHeight: 40
                                    radius: Theme.radiusMd
                                    color: Theme.alpha(Theme.muted, 0.6)
                                    LucideIcon { anchors.centerIn: parent; name: modelData.icon; size: 16; color: Theme.foreground }
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 0
                                    Text { text: modelData.name; color: Theme.foreground; font.pixelSize: Theme.textSm; font.weight: Font.Medium }
                                    Text { text: modelData.cat; color: Theme.mutedForeground; font.pixelSize: Theme.textXs }
                                }
                                Text { text: modelData.when; color: Theme.mutedForeground; font.pixelSize: Theme.textXs }
                                Text {
                                    text: modelData.amt
                                    font.pixelSize: Theme.textSm; font.weight: Font.DemiBold
                                    color: modelData.pos ? "#10b981" : Theme.foreground
                                    Layout.leftMargin: 8
                                }
                                IconButton { iconName: "ellipsis"; variant: IconButton.Ghost; size: IconButton.Small }
                            }
                        }
                    }
                }
            }

            // ---- Nested 2-col grid: [SidebarNav, Faq] | [Payments, FrontDoor] ----
            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                spacing: 16

                // Left half.
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    spacing: 16

                    // Sidebar Nav (two nav panels).
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignTop
                        spacing: 16
                        SideNavCard {
                            groups: [
                                { label: qsTr("Overview"), items: [
                                    { icon: "layout-dashboard", text: qsTr("Dashboard"), active: true },
                                    { icon: "arrow-left-right", text: qsTr("Transactions"), active: false },
                                    { icon: "trending-up", text: qsTr("Investments"), active: false },
                                    { icon: "building-2", text: qsTr("Accounts"), active: false },
                                    { icon: "pie-chart", text: qsTr("Spending"), active: false }
                                ] },
                                { label: qsTr("Planning"), items: [
                                    { icon: "target", text: qsTr("Goals"), active: false },
                                    { icon: "wallet", text: qsTr("Budget"), active: false },
                                    { icon: "file-bar-chart", text: qsTr("Reports"), active: false },
                                    { icon: "file-text", text: qsTr("Documents"), active: false }
                                ] }
                            ]
                        }
                        SideNavCard {
                            groups: [
                                { label: qsTr("Account"), items: [
                                    { icon: "user", text: qsTr("Profile"), active: false },
                                    { icon: "credit-card", text: qsTr("Billing"), active: true },
                                    { icon: "bell", text: qsTr("Notifications"), active: false },
                                    { icon: "shield", text: qsTr("Security"), active: false },
                                    { icon: "paintbrush", text: qsTr("Appearance"), active: false }
                                ] },
                                { label: qsTr("Support"), items: [
                                    { icon: "circle-help", text: qsTr("Help Center"), active: false },
                                    { icon: "message-square", text: qsTr("Contact Us"), active: false },
                                    { icon: "book-open", text: qsTr("Documentation"), active: false },
                                    { icon: "activity", text: qsTr("Status"), active: false }
                                ] }
                            ]
                        }
                    }

                    // FAQ (tabs + accordion).
                    Card {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignTop
                        CardContent {
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 12
                                Tabs {
                                    id: faqTabs
                                    Layout.fillWidth: true
                                    TabButton { text: qsTr("General") }
                                    TabButton { text: qsTr("Billing") }
                                    TabButton { text: qsTr("Goals") }
                                }
                                StackLayout {
                                    Layout.fillWidth: true
                                    currentIndex: faqTabs.currentIndex

                                    Accordion {
                                        Layout.fillWidth: true
                                        bordered: false
                                        AccordionItem {
                                            title: qsTr("How secure is my financial data with Ledger?")
                                            expanded: true
                                            Text { Layout.fillWidth: true; wrapMode: Text.Wrap; color: Theme.mutedForeground; font.pixelSize: Theme.textXs; text: qsTr("We use bank-level AES-256 encryption, SOC 2 Type II certified infrastructure, and never store your credentials. All connections use read-only access tokens. We are a SEC registered investment advisor.") }
                                        }
                                        AccordionItem {
                                            title: qsTr("How do I connect my bank or investment accounts?")
                                            Text { Layout.fillWidth: true; wrapMode: Text.Wrap; color: Theme.mutedForeground; font.pixelSize: Theme.textXs; text: qsTr("Go to Settings > Linked Accounts and search for your institution. We support over 12,000 banks and brokerages via Plaid and MX.") }
                                        }
                                        AccordionItem {
                                            title: qsTr("Can I export my data for tax purposes?")
                                            last: true
                                            Text { Layout.fillWidth: true; wrapMode: Text.Wrap; color: Theme.mutedForeground; font.pixelSize: Theme.textXs; text: qsTr("Yes. Navigate to Reports > Tax Export to download a CSV or PDF summary of your transactions, dividends, and capital gains for any tax year.") }
                                        }
                                    }

                                    Accordion {
                                        Layout.fillWidth: true
                                        bordered: false
                                        AccordionItem {
                                            title: qsTr("What is the difference between Basic and Pro pricing tiers?")
                                            expanded: true
                                            Text { Layout.fillWidth: true; wrapMode: Text.Wrap; color: Theme.mutedForeground; font.pixelSize: Theme.textXs; text: qsTr("Basic includes budgeting, goal tracking, and up to 3 linked accounts. Pro adds unlimited accounts, dividend tracking, portfolio analysis, and priority support.") }
                                        }
                                        AccordionItem {
                                            title: qsTr("How do I cancel my subscription?")
                                            Text { Layout.fillWidth: true; wrapMode: Text.Wrap; color: Theme.mutedForeground; font.pixelSize: Theme.textXs; text: qsTr("Go to Settings > Billing > Manage Plan and click Cancel. Your access continues until the end of your current billing period.") }
                                        }
                                        AccordionItem {
                                            title: qsTr("Do you offer a free trial?")
                                            last: true
                                            Text { Layout.fillWidth: true; wrapMode: Text.Wrap; color: Theme.mutedForeground; font.pixelSize: Theme.textXs; text: qsTr("Yes. All new accounts start with a 14-day Pro trial. No credit card required.") }
                                        }
                                    }

                                    Accordion {
                                        Layout.fillWidth: true
                                        bordered: false
                                        AccordionItem {
                                            title: qsTr("How do I set up a custom financial goal?")
                                            expanded: true
                                            Text { Layout.fillWidth: true; wrapMode: Text.Wrap; color: Theme.mutedForeground; font.pixelSize: Theme.textXs; text: qsTr("Click New Goal from the Savings Targets card. Choose a category, set a target amount and date, and we'll calculate the monthly contribution needed.") }
                                        }
                                        AccordionItem {
                                            title: qsTr("Can I track multiple goals at once?")
                                            Text { Layout.fillWidth: true; wrapMode: Text.Wrap; color: Theme.mutedForeground; font.pixelSize: Theme.textXs; text: qsTr("Yes. Pro accounts can track unlimited goals. Basic accounts support up to 3 active goals.") }
                                        }
                                        AccordionItem {
                                            title: qsTr("How are monthly contributions calculated?")
                                            last: true
                                            Text { Layout.fillWidth: true; wrapMode: Text.Wrap; color: Theme.mutedForeground; font.pixelSize: Theme.textXs; text: qsTr("We divide the remaining amount by the number of months until your target date, adjusted for your current savings rate and any auto-transfer schedules.") }
                                        }
                                    }
                                }
                            }
                        }
                        CardFooter {
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 8
                                Button { Layout.fillWidth: true; text: qsTr("Contact Support"); variant: Button.Outline }
                                Button { Layout.fillWidth: true; text: qsTr("Learn More"); variant: Button.Link }
                            }
                        }
                    }
                }

                // Right half.
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    spacing: 16

                    // Payments (breadcrumb + link list).
                    Card {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignTop
                        CardHeader {
                            Breadcrumb {
                                BreadcrumbItem {
                                    BreadcrumbLink { text: qsTr("Home") }
                                }
                                BreadcrumbSeparator {}
                                BreadcrumbItem {
                                    IconButton {
                                        id: paymentsMore
                                        size: IconButton.Small
                                        variant: IconButton.Ghost
                                        iconName: "ellipsis"
                                        onClicked: paymentsMenu.popup(0, paymentsMore.height + 4)
                                        Menu {
                                            id: paymentsMenu
                                            MenuItem { text: qsTr("Profile") }
                                            MenuItem { text: qsTr("Statements") }
                                            MenuItem { text: qsTr("Documents") }
                                        }
                                    }
                                }
                                BreadcrumbSeparator {}
                                BreadcrumbItem {
                                    BreadcrumbPage { text: qsTr("Payments") }
                                }
                            }
                        }
                        CardContent {
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 8
                                Repeater {
                                    model: [
                                        { icon: "gauge", title: qsTr("Change transfer limit"), desc: qsTr("Adjust how much you can send from your balance.") },
                                        { icon: "calendar", title: qsTr("Scheduled transfers"), desc: qsTr("Set up a transfer to send at a later date.") },
                                        { icon: "repeat", title: qsTr("Direct Debits"), desc: qsTr("Set up and manage regular payments.") },
                                        { icon: "refresh-cw", title: qsTr("Recurring card payments"), desc: qsTr("Manage your repeated card transactions.") }
                                    ]
                                    delegate: MutedRow {
                                        required property var modelData
                                        Rectangle {
                                            implicitWidth: 32; implicitHeight: 32
                                            radius: Theme.radiusMd
                                            color: Theme.alpha(Theme.muted, 0.8)
                                            border.width: 1
                                            border.color: Theme.border
                                            LucideIcon { anchors.centerIn: parent; name: modelData.icon; size: 16; color: Theme.foreground }
                                        }
                                        ColumnLayout {
                                            Layout.fillWidth: true
                                            spacing: 0
                                            Text { text: modelData.title; color: Theme.foreground; font.pixelSize: Theme.textSm; font.weight: Font.Medium }
                                            Text { Layout.fillWidth: true; text: modelData.desc; color: Theme.mutedForeground; font.pixelSize: Theme.textXs; elide: Text.ElideRight }
                                        }
                                        LucideIcon { name: "chevron-right"; size: 16; color: Theme.mutedForeground }
                                    }
                                }
                            }
                        }
                    }

                    // Front Door (smart lock camera feed).
                    Card {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignTop
                        RowLayout {
                            Layout.fillWidth: true
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4
                                CardTitle { text: qsTr("Front Door") }
                                CardDescription { text: qsTr("Smart Lock Pro") }
                            }
                            RowLayout {
                                Layout.alignment: Qt.AlignVCenter
                                spacing: 6
                                Muted { text: qsTr("Locked") }
                                LucideIcon { name: "lock"; size: 16; color: Theme.mutedForeground }
                            }
                        }
                        CardContent {
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: width * 9 / 16
                                radius: Theme.radiusLg
                                color: Theme.muted
                                clip: true
                                DiagonalHatch { anchors.fill: parent }
                                Badge {
                                    variant: Badge.Destructive
                                    text: qsTr("Live")
                                    anchors.top: parent.top
                                    anchors.right: parent.right
                                    anchors.margins: 8
                                }
                            }
                        }
                    }
                }
            }

            // ---- Release Catalog (search + toggle + holdings list) ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        InputGroup {
                            Layout.fillWidth: true
                            Layout.maximumWidth: 360
                            InputGroupAddon {
                                LucideIcon { name: "search"; size: 14; color: Theme.mutedForeground }
                            }
                            InputGroupInput { placeholderText: qsTr("Search holdings or tickers...") }
                        }
                        Item { Layout.fillWidth: true }
                        ToggleGroup {
                            variant: ToggleGroup.Outline
                            spacing: 1
                            ToggleGroupItem { value: "stocks"; text: qsTr("Stocks") }
                            ToggleGroupItem { value: "etfs"; text: qsTr("ETFs"); checked: true }
                            ToggleGroupItem { value: "reits"; text: qsTr("REITs") }
                        }
                    }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        Repeater {
                            model: [
                                { ticker: "VOO", name: qsTr("Vanguard S&P 500 ETF"), type: qsTr("ETF"), added: qsTr("Jan 2021"), shares: "112", value: "$48,230.40" },
                                { ticker: "VIG", name: qsTr("Vanguard Dividend Appreciation"), type: qsTr("ETF"), added: qsTr("Mar 2022"), shares: "450", value: "$26,033.79" },
                                { ticker: "AAPL", name: qsTr("Apple Inc."), type: qsTr("Stock"), added: qsTr("Nov 2020"), shares: "85", value: "$18,488.90" },
                                { ticker: "O", name: qsTr("Realty Income Corp"), type: qsTr("REIT"), added: qsTr("Jun 2023"), shares: "320", value: "$15,136.59" }
                            ]
                            delegate: MutedRow {
                                required property var modelData
                                Rectangle {
                                    implicitWidth: 48; implicitHeight: 48
                                    radius: Theme.radiusMd
                                    color: "transparent"
                                    border.width: 1
                                    border.color: Theme.border
                                    Text { anchors.centerIn: parent; text: modelData.ticker; color: Theme.foreground; font.pixelSize: Theme.textSm; font.weight: Font.DemiBold }
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 2
                                    Text { text: modelData.name; color: Theme.foreground; font.pixelSize: Theme.textSm; font.weight: Font.Medium }
                                    Text { text: modelData.shares + qsTr(" Shares · ") + modelData.added; color: Theme.mutedForeground; font.pixelSize: Theme.textXs; font.letterSpacing: 0.5 }
                                }
                                Badge { variant: Badge.Outline; text: modelData.type }
                                ColumnLayout {
                                    Layout.leftMargin: 12
                                    spacing: 2
                                    Text { Layout.alignment: Qt.AlignRight; text: qsTr("VALUE"); color: Theme.mutedForeground; font.pixelSize: Theme.textXs; font.letterSpacing: 0.5 }
                                    Text { Layout.alignment: Qt.AlignRight; text: modelData.value; color: Theme.foreground; font.pixelSize: Theme.textSm; font.weight: Font.Medium; font.family: Theme.fontMono }
                                }
                            }
                        }
                    }
                }
            }
        }

        // ============================ Column 4 ============================
        // AccountAccess · CardOverview · TransferFunds · CoverArt · LoadingCard
        ColumnLayout {
            Layout.preferredWidth: 360
            Layout.minimumWidth: 360
            Layout.maximumWidth: 360
            Layout.alignment: Qt.AlignTop
            spacing: 16

            // ---- Account Access ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("Account Access") }
                    CardDescription { text: qsTr("Update your credentials or re-authenticate.") }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 14
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("Email Address") }
                            Input { Layout.fillWidth: true; text: qsTr("artist@studio.inc") }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            RowLayout {
                                Layout.fillWidth: true
                                Label { Layout.fillWidth: true; text: qsTr("Current Password") }
                                Text { text: qsTr("FORGOT?"); color: Theme.mutedForeground; font.pixelSize: Theme.textXs; font.weight: Font.Medium; font.letterSpacing: 0.6 }
                            }
                            Input { Layout.fillWidth: true; text: "password123"; echoMode: TextInput.Password }
                        }
                    }
                }
                CardFooter {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        Button { Layout.fillWidth: true; text: qsTr("Update Security"); iconName: "lock-keyhole" }
                        MutedBox {
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 12
                                Rectangle {
                                    implicitWidth: 36; implicitHeight: 36
                                    radius: Theme.radiusMd
                                    color: Theme.alpha(Theme.muted, 0.8)
                                    LucideIcon { anchors.centerIn: parent; name: "circle-alert"; size: 16; color: Theme.destructive }
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 0
                                    Stat { text: qsTr("Danger Zone"); font.pixelSize: Theme.textSm }
                                    Muted { Layout.fillWidth: true; text: qsTr("Archive account and remove catalog"); font.pixelSize: Theme.textXs; elide: Text.ElideRight }
                                }
                                LucideIcon { name: "arrow-right"; size: 16; color: Theme.mutedForeground }
                            }
                        }
                    }
                }
            }

            // ---- Card Overview (2 stats + activity chart) ----
            Card {
                Layout.fillWidth: true
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            MutedBox {
                                Muted { text: qsTr("Card Balance") }
                                Stat { text: qsTr("US$12.94"); font.pixelSize: Theme.textXl }
                                Muted { text: qsTr("US$11,337.06 Available"); font.pixelSize: Theme.textXs }
                            }
                            MutedBox {
                                Muted { text: qsTr("Payment Due") }
                                Stat { text: qsTr("1 Apr"); font.pixelSize: Theme.textXl }
                                Button { Layout.fillWidth: true; text: qsTr("Pay Early"); variant: Button.Outline; size: Button.Sm }
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Muted { Layout.fillWidth: true; text: qsTr("Yearly Activity") }
                            Badge { variant: Badge.Secondary; text: qsTr("+US$0.25 Daily Cash") }
                        }
                        Chart {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 84
                            type: Chart.Bar
                            categoryKey: "month"
                            barRadius: 3
                            showXAxis: true
                            xTickFormatter: function (v) { return String(v).charAt(0) }
                            series: [ { key: "amount", label: qsTr("Activity"), color: Theme.chart2 } ]
                            chartData: [
                                { month: "Jan", amount: 40 }, { month: "Feb", amount: 55 }, { month: "Mar", amount: 35 },
                                { month: "Apr", amount: 60 }, { month: "May", amount: 45 }, { month: "Jun", amount: 50 },
                                { month: "Jul", amount: 65 }, { month: "Aug", amount: 40 }, { month: "Sep", amount: 55 },
                                { month: "Oct", amount: 70 }, { month: "Nov", amount: 45 }, { month: "Dec", amount: 80 }
                            ]
                        }
                    }
                }
            }

            // ---- Transfer Funds ----
            Card {
                Layout.fillWidth: true
                RowLayout {
                    Layout.fillWidth: true
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        CardTitle { text: qsTr("Transfer Funds") }
                        CardDescription { text: qsTr("Move money between your connected accounts.") }
                    }
                    IconButton { iconName: "x"; variant: IconButton.Ghost; size: IconButton.Small; Layout.alignment: Qt.AlignTop }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 14
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("Amount to Transfer") }
                            InputGroup {
                                Layout.fillWidth: true
                                InputGroupAddon { InputGroupText { text: qsTr("$") } }
                                InputGroupInput { text: qsTr("1,200.00") }
                            }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("From Account") }
                            Select { Layout.fillWidth: true; model: ["Main Checking (··8402) — $12,450.00", "Business (··7731) — $8,920.00"] }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("To Account") }
                            Select { Layout.fillWidth: true; model: ["High Yield Savings (··1192) — $42,100.00", "Investment (··3349) — $18,200.00"] }
                        }
                        MutedBox {
                            InfoRow { label: qsTr("Estimated arrival"); value: qsTr("Today, Apr 14") }
                            Separator { Layout.fillWidth: true }
                            InfoRow { label: qsTr("Transaction fee"); value: qsTr("$0.00") }
                            Separator { Layout.fillWidth: true }
                            InfoRow { label: qsTr("Total amount"); value: qsTr("$1,200.00"); valueWeight: Font.DemiBold }
                        }
                    }
                }
                CardFooter {
                    Button { Layout.fillWidth: true; text: qsTr("Confirm Transfer") }
                }
            }

            // ---- Cover Art (upload placeholder) ----
            Card {
                Layout.fillWidth: true
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        Label { Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; text: qsTr("COVER ART"); color: Theme.mutedForeground; font.pixelSize: Theme.textXs; font.weight: Font.Normal; font.letterSpacing: 0.6 }
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: width
                            radius: Theme.radiusLg
                            color: "transparent"
                            border.width: 1
                            border.color: Theme.border
                            LucideIcon { anchors.centerIn: parent; name: "image"; size: 40; color: Theme.alpha(Theme.mutedForeground, 0.5) }
                        }
                    }
                }
                CardFooter {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        Button { Layout.fillWidth: true; text: qsTr("Upload Artwork"); variant: Button.Secondary }
                        CardDescription { Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; text: qsTr("Minimum 3000 × 3000px\nJPEG or PNG only"); font.pixelSize: Theme.textXs }
                    }
                }
            }

            // ---- Loading Card (skeletons) ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    Skeleton { Layout.preferredWidth: 128; Layout.preferredHeight: 20 }
                    Skeleton { Layout.preferredWidth: 192; Layout.preferredHeight: 16 }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        Skeleton { Layout.fillWidth: true; Layout.preferredHeight: 128; radius: Theme.radiusLg }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8
                            Skeleton { Layout.fillWidth: true; Layout.preferredHeight: 16 }
                            Skeleton { Layout.preferredWidth: parent.width * 0.75; Layout.preferredHeight: 16 }
                            Skeleton { Layout.preferredWidth: parent.width * 0.5; Layout.preferredHeight: 16 }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8
                            Skeleton { Layout.fillWidth: true; Layout.preferredHeight: 36; radius: Theme.radiusMd }
                            Skeleton { Layout.fillWidth: true; Layout.preferredHeight: 36; radius: Theme.radiusMd }
                        }
                    }
                }
            }
        }

        // ============================ Column 5 ============================
        // ReceivingMethod · PowerUsage · EmptyConnectBank · UpcomingPayments
        // · RollerShades
        ColumnLayout {
            Layout.preferredWidth: 360
            Layout.minimumWidth: 360
            Layout.maximumWidth: 360
            Layout.alignment: Qt.AlignTop
            spacing: 16

            // ---- Receiving Method ----
            Card {
                Layout.fillWidth: true
                RowLayout {
                    Layout.fillWidth: true
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        CardDescription { text: qsTr("Payout Preferences") }
                        CardTitle { text: qsTr("Receiving Method") }
                    }
                    IconButton { iconName: "x"; variant: IconButton.Ghost; size: IconButton.Small; Layout.alignment: Qt.AlignTop }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 14
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("Account Holder Name") }
                            Input { Layout.fillWidth: true; text: qsTr("Synthetic Horizons Music LLC") }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("Receiving Method") }
                            RadioGroup {
                                Layout.fillWidth: true
                                Layout.topMargin: 2
                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 10
                                    RadioButton { checked: true; Layout.alignment: Qt.AlignTop }
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 0
                                        Text { text: qsTr("Bank Transfer"); color: Theme.foreground; font.pixelSize: Theme.textSm; font.weight: Font.Medium }
                                        Muted { text: qsTr("SWIFT / IBAN"); font.pixelSize: Theme.textXs }
                                    }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 10
                                    RadioButton { Layout.alignment: Qt.AlignTop }
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 0
                                        Text { text: qsTr("PayPal"); color: Theme.foreground; font.pixelSize: Theme.textSm; font.weight: Font.Medium }
                                        Muted { text: qsTr("Instant Payout"); font.pixelSize: Theme.textXs }
                                    }
                                }
                            }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("IBAN / Account Number") }
                            Input { Layout.fillWidth: true; placeholderText: qsTr("DE89 3704 0044 ....") }
                        }
                    }
                }
                CardFooter {
                    Button { Layout.fillWidth: true; text: qsTr("Save Payout Settings"); enabled: false }
                }
            }

            // ---- Power Usage ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("Power Usage") }
                    CardDescription { text: qsTr("Whole Home") }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        Chart {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 140
                            type: Chart.Bar
                            categoryKey: "hour"
                            barRadius: 4
                            showXAxis: true
                            hideTooltipLabel: true
                            tooltipCursor: false
                            series: [ { key: "usage", label: qsTr("Usage (kW)"), color: Theme.chart2 } ]
                            chartData: [
                                { hour: "6a", usage: 1.2 }, { hour: "8a", usage: 2.8 }, { hour: "10a", usage: 3.1 },
                                { hour: "12p", usage: 2.4 }, { hour: "2p", usage: 3.4 }, { hour: "4p", usage: 2.9 },
                                { hour: "6p", usage: 3.8 }, { hour: "8p", usage: 3.2 }
                            ]
                        }
                        Separator { Layout.fillWidth: true }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 16
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                Muted { text: qsTr("Currently Using") }
                                Stat { text: qsTr("3.4 kW"); font.pixelSize: Theme.textLg }
                            }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                Muted { text: qsTr("Solar Gen") }
                                Stat { text: qsTr("+1.2 kW"); font.pixelSize: Theme.textLg; color: Theme.chart1 }
                            }
                        }
                    }
                }
                CardFooter {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        Muted { text: qsTr("Battery Level") }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8
                            Progress { Layout.fillWidth: true; value: 85 }
                            Text { text: qsTr("85%"); color: Theme.foreground; font.pixelSize: Theme.textSm; font.weight: Font.Medium; font.family: Theme.fontMono }
                        }
                    }
                }
            }

            // ---- Empty: Connect Bank ----
            Card {
                Layout.fillWidth: true
                CardContent {
                    Empty {
                        Layout.fillWidth: true
                        EmptyHeader {
                            EmptyMedia { variant: EmptyMedia.Icon; iconName: "credit-card" }
                            EmptyTitle { text: qsTr("Connect Bank") }
                            EmptyDescription {
                                text: qsTr("Link your payout method to receive monthly royalty distributions automatically.")
                            }
                        }
                        EmptyContent {
                            Button { Layout.alignment: Qt.AlignHCenter; text: qsTr("Set Up Payouts") }
                        }
                    }
                }
            }

            // ---- Upcoming Payments (calendar + schedule) ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("Upcoming Payments") }
                    CardDescription { text: qsTr("Select a date to view scheduled payments.") }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        Rectangle {
                            Layout.fillWidth: true
                            radius: Theme.radiusLg
                            color: "transparent"
                            border.width: 1
                            border.color: Theme.border
                            implicitHeight: cal.implicitHeight + 24
                            Calendar { id: cal; anchors.centerIn: parent }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8
                            Repeater {
                                model: [
                                    { name: qsTr("Netflix Subscription"), date: qsTr("Apr 15, 2024"), amt: "$19.99" },
                                    { name: qsTr("Rent Payment"), date: qsTr("Apr 1, 2024"), amt: "$2,400.00" },
                                    { name: qsTr("Auto Insurance"), date: qsTr("Apr 22, 2024"), amt: "$186.00" }
                                ]
                                delegate: MutedRow {
                                    required property var modelData
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 0
                                        Text { text: modelData.name; color: Theme.foreground; font.pixelSize: Theme.textSm; font.weight: Font.Medium }
                                        Text { text: modelData.date; color: Theme.mutedForeground; font.pixelSize: Theme.textXs }
                                    }
                                    Badge { variant: Badge.Secondary; text: modelData.amt }
                                }
                            }
                        }
                    }
                }
            }

            // ---- Roller Shades ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("Living Room") }
                    CardDescription { text: qsTr("Roller Shades") }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 128
                            radius: Theme.radiusLg
                            color: Theme.muted
                            border.width: 1
                            border.color: Theme.border
                            clip: true
                            Rectangle {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                                height: parent.height * shadeSlider.value / 100
                                color: Theme.mutedForeground
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            Kicker { text: qsTr("OPEN") }
                            Slider { id: shadeSlider; Layout.fillWidth: true; from: 0; to: 100; value: 50 }
                            Kicker { text: qsTr("CLOSE") }
                        }
                    }
                }
                CardFooter {
                    ToggleGroup {
                        Layout.fillWidth: true
                        variant: ToggleGroup.Outline
                        spacing: 1
                        ToggleGroupItem { value: "open"; text: qsTr("Open"); onCheckedChanged: if (checked) shadeSlider.value = 0 }
                        ToggleGroupItem { value: "half"; text: qsTr("Half"); checked: true; onCheckedChanged: if (checked) shadeSlider.value = 50 }
                        ToggleGroupItem { value: "closed"; text: qsTr("Closed"); onCheckedChanged: if (checked) shadeSlider.value = 100 }
                    }
                }
            }
        }

        // ============================ Column 6 ============================
        // StockPerformance · EmptyExploreCatalog · NewMilestone · SocialLinks
        // · NotificationSettings
        ColumnLayout {
            Layout.preferredWidth: 360
            Layout.minimumWidth: 360
            Layout.maximumWidth: 360
            Layout.alignment: Qt.AlignTop
            spacing: 16

            // ---- Stock Performance (combobox + area chart) ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("Stock Performance") }
                    CardDescription { text: qsTr("6-month price history.") }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("Ticker") }
                            Combobox {
                                Layout.fillWidth: true
                                placeholder: qsTr("Search ticker...")
                                emptyText: qsTr("No tickers found.")
                                currentValue: "VOO"
                                model: ["VOO", "VIG", "AAPL", "MSFT", "GOOGL", "AMZN", "TSLA"]
                            }
                        }
                        Separator { Layout.fillWidth: true }
                        Chart {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 200
                            type: Chart.Area
                            categoryKey: "month"
                            curved: true
                            areaGradient: true
                            areaFillOpacity: 0.3
                            showGrid: true
                            showXAxis: false
                            showLegend: false
                            hideTooltipLabel: true
                            series: [ { key: "price", label: qsTr("Price"), color: Theme.chart1 } ]
                            chartData: [
                                { month: "Jan", price: 412 }, { month: "Feb", price: 438 }, { month: "Mar", price: 395 },
                                { month: "Apr", price: 450 }, { month: "May", price: 420 }, { month: "Jun", price: 462 }
                            ]
                        }
                    }
                }
            }

            // ---- Empty: Explore Catalog ----
            Card {
                Layout.fillWidth: true
                CardContent {
                    Empty {
                        Layout.fillWidth: true
                        EmptyHeader {
                            EmptyMedia { variant: EmptyMedia.Icon; iconName: "audio-lines" }
                            EmptyTitle { text: qsTr("Explore Catalog") }
                            EmptyDescription {
                                text: qsTr("Check your ISRC codes, metadata, and visual assets before going live.")
                            }
                        }
                        EmptyContent {
                            Button { Layout.alignment: Qt.AlignHCenter; text: qsTr("View Catalog") }
                        }
                    }
                }
            }

            // ---- New Milestone ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("Set a new milestone") }
                    CardDescription { text: qsTr("Define your financial target and we'll help you pace your savings.") }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 14
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Label { text: qsTr("Goal Name") }
                            Input { Layout.fillWidth: true; placeholderText: qsTr("e.g. New Car, Home Downpayment") }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 6
                                Label { text: qsTr("Target Amount") }
                                Input { Layout.fillWidth: true; text: qsTr("$15,000") }
                            }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 6
                                Label { text: qsTr("Target Date") }
                                Input { Layout.fillWidth: true; text: qsTr("Dec 2025") }
                            }
                        }
                    }
                }
                CardFooter {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        Button { Layout.fillWidth: true; text: qsTr("Create Goal") }
                        Button { Layout.fillWidth: true; text: qsTr("Cancel"); variant: Button.Outline }
                    }
                }
            }

            // ---- Social Links ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("Social Links") }
                }
                CardContent {
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 14
                        Repeater {
                            model: [
                                { label: qsTr("Spotify Artist URL"), icon: "circle-plus", value: qsTr("spotify.com/artist/3j...2k"), placeholder: "" },
                                { label: qsTr("Instagram Handle"), icon: "camera", value: qsTr("@julianduryea_music"), placeholder: "" },
                                { label: qsTr("SoundCloud URL"), icon: "cloud", value: "", placeholder: qsTr("soundcloud.com/username") },
                                { label: qsTr("Website"), icon: "globe", value: "", placeholder: qsTr("https://yoursite.com") }
                            ]
                            delegate: ColumnLayout {
                                required property var modelData
                                Layout.fillWidth: true
                                spacing: 6
                                Label { text: modelData.label }
                                InputGroup {
                                    Layout.fillWidth: true
                                    InputGroupAddon {
                                        LucideIcon { name: modelData.icon; size: 14; color: Theme.mutedForeground }
                                    }
                                    InputGroupInput { text: modelData.value; placeholderText: modelData.placeholder }
                                }
                            }
                        }
                    }
                }
                CardFooter {
                    Item { Layout.fillWidth: true }
                    Button { text: qsTr("Discard"); variant: Button.Secondary }
                    Button { text: qsTr("Save Changes") }
                }
            }

            // ---- Notification Settings ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardTitle { text: qsTr("Notifications") }
                    CardDescription { text: qsTr("Choose what you want to be notified about.") }
                }
                CardContent {
                    ColumnLayout {
                        id: notif
                        Layout.fillWidth: true
                        spacing: 14
                        function refreshAll() { selectAll.checked = cb0.checked && cb1.checked && cb2.checked && cb3.checked }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10
                            Checkbox {
                                id: selectAll
                                Layout.alignment: Qt.AlignVCenter
                                onToggled: { cb0.checked = checked; cb1.checked = checked; cb2.checked = checked; cb3.checked = checked }
                            }
                            Label { text: qsTr("Select all"); Layout.alignment: Qt.AlignVCenter }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10
                            Checkbox { id: cb0; checked: true; Layout.alignment: Qt.AlignTop; onToggled: notif.refreshAll() }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0
                                Label { text: qsTr("Transaction alerts") }
                                Muted { Layout.fillWidth: true; text: qsTr("Deposits, withdrawals, and transfers."); font.pixelSize: Theme.textXs; wrapMode: Text.Wrap }
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10
                            Checkbox { id: cb1; checked: true; Layout.alignment: Qt.AlignTop; onToggled: notif.refreshAll() }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0
                                Label { text: qsTr("Security alerts") }
                                Muted { Layout.fillWidth: true; text: qsTr("Login attempts and account changes."); font.pixelSize: Theme.textXs; wrapMode: Text.Wrap }
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10
                            Checkbox { id: cb2; Layout.alignment: Qt.AlignTop; onToggled: notif.refreshAll() }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0
                                Label { text: qsTr("Goal milestones") }
                                Muted { Layout.fillWidth: true; text: qsTr("Updates at 25%, 50%, 75%, and 100%."); font.pixelSize: Theme.textXs; wrapMode: Text.Wrap }
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10
                            Checkbox { id: cb3; Layout.alignment: Qt.AlignTop; onToggled: notif.refreshAll() }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0
                                Label { text: qsTr("Market updates") }
                                Muted { Layout.fillWidth: true; text: qsTr("Daily portfolio summary and price alerts."); font.pixelSize: Theme.textXs; wrapMode: Text.Wrap }
                            }
                        }
                        Component.onCompleted: refreshAll()
                    }
                }
                CardFooter {
                    Button { Layout.fillWidth: true; text: qsTr("Save Preferences") }
                }
            }
        }

        Item { Layout.preferredWidth: 8 }   // Trailing whitespace
    }
}
