import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// Live-preview dashboard for the Create page — a QML port of shadcn's
// registry `preview-02` bento block (apps/v4/registry/bases/base/blocks/
// preview-02). A horizontally-scrolling grid of realistic app cards that all
// re-theme through the Theme override layer. First batch of cards; more can be
// ported one-to-one from the reference cards/*.tsx.
ScrollView {
    id: root
    clip: true
    contentHeight: availableHeight   // horizontal scroll only

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

    RowLayout {
        height: root.availableHeight
        spacing: 16

        // ============================ Column 1 ============================
        ColumnLayout {
            Layout.preferredWidth: 360
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

            // ---- Claimable Balance ----
            Card {
                Layout.fillWidth: true
                CardHeader {
                    CardDescription { text: qsTr("Claimable Balance") }
                    CardTitle { text: qsTr("$0.00"); font.pixelSize: 40 }
                    Badge { variant: Badge.Outline; text: qsTr("Pending Setup") }
                }
                CardContent {
                    MutedBox {
                        RowLayout {
                            Layout.fillWidth: true
                            Muted { Layout.fillWidth: true; text: qsTr("Net Royalties") }
                            Stat { text: qsTr("$0.00"); font.pixelSize: Theme.textSm; font.weight: Font.Medium }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Muted { Layout.fillWidth: true; text: qsTr("Processing Fee") }
                            Stat { text: qsTr("-$0.00"); font.pixelSize: Theme.textSm; font.weight: Font.Medium }
                        }
                        Separator { Layout.fillWidth: true }
                        RowLayout {
                            Layout.fillWidth: true
                            Muted { Layout.fillWidth: true; text: qsTr("Total Ready to Claim") }
                            Stat { text: qsTr("$0.00 USD"); font.pixelSize: Theme.textSm }
                        }
                    }
                }
                CardFooter {
                    CardDescription { Layout.fillWidth: true; text: qsTr("Once your bank is connected, balances over $10.00 are automatically eligible for monthly distribution on the 15th of each month.") }
                }
            }
        }

        // ============================ Column 2 ============================
        ColumnLayout {
            Layout.preferredWidth: 360
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
        }

        // ============================ Column 3 (wide) ============================
        ColumnLayout {
            Layout.preferredWidth: 740
            Layout.alignment: Qt.AlignTop
            spacing: 16

            // ---- Savings Targets + Buy Investment (side by side) ----
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
                            RowLayout {
                                Layout.fillWidth: true
                                Muted { Layout.fillWidth: true; text: qsTr("Estimated Shares") }
                                Stat { text: qsTr("1.95"); font.pixelSize: Theme.textSm }
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                Muted { Layout.fillWidth: true; text: qsTr("Buying Power") }
                                Stat { text: qsTr("$12,450.00"); font.pixelSize: Theme.textSm }
                            }
                        }
                    }
                    CardFooter {
                        Button { Layout.fillWidth: true; text: qsTr("Review Order") }
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
        }

        Item { Layout.preferredWidth: 8 }   // Trailing whitespace
    }
}
