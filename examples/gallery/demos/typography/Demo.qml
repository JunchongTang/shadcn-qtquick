import QtQuick
import QtQuick.Layouts
import Shadcn

// typography-demo -- full typography sample (heading hierarchy + paragraphs + links + blockquote + list + table).
// Paragraph spacing aligned with Official: h2 mt-10, h3 mt-8, blockquote/ul/table/p mt-6 (my-6).
ColumnLayout {
    id: article
    width: 600
    spacing: 0

    TypographyH1 {
        Layout.fillWidth: true
        text: qsTr("Taxing Laughter: The Joke Tax Chronicles")
    }
    TypographyLead {
        Layout.fillWidth: true
        Layout.topMargin: 24
        text: qsTr("Once upon a time, in a far-off land, there was a very lazy king who ")
            + "spent all day lounging on his throne. One day, his advisors came to him "
            + "with a problem: the kingdom was running out of money."
    }

    TypographyH2 {
        Layout.fillWidth: true
        Layout.topMargin: 40
        text: qsTr("The King's Plan")
    }
    TypographyP {
        Layout.fillWidth: true
        Layout.topMargin: 24
        textFormat: Text.RichText
        text: qsTr("The king thought long and hard, and finally came up with ")
            + "<a href=\"#\" style=\"color:" + Theme.primary
            + ";text-decoration:underline;\">a brilliant plan</a>"
            + ": he would tax the jokes in the kingdom."
    }

    TypographyBlockquote {
        Layout.fillWidth: true
        Layout.topMargin: 24
        text: qsTr("\"After all,\" he said, \"everyone enjoys a good joke, so ")
            + "it's only fair that they should pay for the privilege.\""
    }

    TypographyH3 {
        Layout.fillWidth: true
        Layout.topMargin: 32
        text: qsTr("The Joke Tax")
    }
    TypographyP {
        Layout.fillWidth: true
        Layout.topMargin: 24
        text: qsTr("The king's subjects were not amused. They grumbled and complained, ")
            + "but the king was firm:"
    }
    TypographyList {
        Layout.topMargin: 24
        items: [
            "1st level of puns: 5 gold coins",
            "2nd level of jokes: 10 gold coins",
            "3rd level of one-liners : 20 gold coins"
        ]
    }
    TypographyP {
        Layout.fillWidth: true
        Layout.topMargin: 24
        text: qsTr("As a result, people stopped telling jokes, and the kingdom fell into a ")
            + "gloom. But there was one person who refused to let the king's "
            + "foolishness get him down: a court jester named Jokester."
    }

    TypographyH3 {
        Layout.fillWidth: true
        Layout.topMargin: 32
        text: qsTr("Jokester's Revolt")
    }
    TypographyP {
        Layout.fillWidth: true
        Layout.topMargin: 24
        text: qsTr("Jokester began sneaking into the castle in the middle of the night and ")
            + "leaving jokes all over the place: under the king's pillow, in his "
            + "soup, even in the royal toilet. The king was furious, but he "
            + "couldn't seem to stop Jokester."
    }
    TypographyP {
        Layout.fillWidth: true
        Layout.topMargin: 24
        text: qsTr("And then, one day, the people of the kingdom discovered that the jokes ")
            + "left by Jokester were so funny that they couldn't help but laugh. "
            + "And once they started laughing, they couldn't stop."
    }

    TypographyH3 {
        Layout.fillWidth: true
        Layout.topMargin: 32
        text: qsTr("The People's Rebellion")
    }
    TypographyP {
        Layout.fillWidth: true
        Layout.topMargin: 24
        text: qsTr("The people of the kingdom, feeling uplifted by the laughter, started to ")
            + "tell jokes and puns again, and soon the entire kingdom was in on the joke."
    }

    TypographyTable {
        Layout.fillWidth: true
        Layout.topMargin: 24
        headers: ["King's Treasury", "People's happiness"]
        rows: [
            ["Empty", "Overflowing"],
            ["Modest", "Satisfied"],
            ["Full", "Ecstatic"]
        ]
    }

    TypographyP {
        Layout.fillWidth: true
        Layout.topMargin: 24
        text: qsTr("The king, seeing how much happier his subjects were, realized the error ")
            + "of his ways and repealed the joke tax. Jokester was declared a hero, and "
            + "the kingdom lived happily ever after."
    }
    TypographyP {
        Layout.fillWidth: true
        Layout.topMargin: 24
        text: qsTr("The moral of the story is: never underestimate the power of a good laugh ")
            + "and always be careful of bad ideas."
    }
}
