import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1

Rectangle {
    id: page

    Item{
        id: theme
        property int paddingSmall: (5 / 2) * Screen.pixelDensity
        property int paddingMedium: (15 / 4) * Screen.pixelDensity
        property int paddingLarge: 4 * Screen.pixelDensity
        property int fontSizeSmall: 16
        property int fontSizeMedium: 20
        property int fontSizeLarge: 24
        property int itemSizeLarge: 30
        property color primaryColor: '#000000'
        property color highlightColor: '#8888ff'
        property color invertedColor: '#ffffff'
        property color headerColor: 'lightgray'
    }

    ToolBar {
        id: header
        z: 3
        visible: true
        RowLayout {
            anchors.fill: parent
            anchors.margins: spacing

            Label {
                text: '< Help'
                font.pointSize: theme.fontSizeLarge
                MouseArea{
                    anchors.fill: parent
                    onClicked: pageStack.pop()
                }
            }
        }
     }


    // Fixes text flow issue with older android versions
    Rectangle {
        color: theme.headerColor
        height: header.height
        width: header.width
        z: 2
    }

    Flickable {
        height: parent.height - header.height
        width: parent.width
        y: header.height
        z: 1
        contentHeight: col.height + 10
        id: flick

        onWidthChanged: {
            if(width > Math.round(170 * Screen.pixelDensity)){
                col.width = Math.round(170 * Screen.pixelDensity);
            }
            else{
                col.width = width;
            }
        }

        Column {
            id: col
            width: parent.width
            anchors.margins: theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: theme.paddingMedium

            // Ugly spacer
            Label {
                text: ' '
                font.pointSize: theme.fontSizeSmall
                anchors{
                    left: parent.left
                }
            }

            Label {
                text: "The Basics"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text:   'Pixl is a game about evolution. You start with three moose that will move around, search for food and create new moose. You can feed them, look at them or give them weird names. The possibilities are endless. You could also name them after your enemies and let them die if your\'re into that. So do whatever you want and have fun.'
                font.pointSize: theme.fontSizeSmall
                wrapMode: Text.WordWrap
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: theme.paddingMedium
                    rightMargin: theme.paddingMedium
                }
            }

            Label {
                text: "Controls"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text:   'You can spawn food by tapping on the screen. By tapping on a specific animal, you show/hide its name and energy status. If the game is paused, this will also show additional info on the bottom of the screen. Tapping on this info will take you to the animals stats page. Animal stats can be accessed from the "Info" menu. You can also access the "Settings" page from there where you can activate the "Night mode", adjust the food spawn rate and enable various debug options. It is also possible to change an animals name from its stats page.'
                font.pointSize: theme.fontSizeSmall
                wrapMode: Text.WordWrap
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: theme.paddingMedium
                    rightMargin: theme.paddingMedium
                }
            }

            Label {
                text: "DNA"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text:   'Every moose has a unique DNA that defines how that moose behaves, how fast, clever or hungry he is. When two animals mate, their DNA is combined and a new animal with that DNA is spawned. An animals DNA massively influences its lifespan and character.'
                font.pointSize: theme.fontSizeSmall
                wrapMode: Text.WordWrap
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: theme.paddingMedium
                    rightMargin: theme.paddingMedium
                }
            }

            Label {
                text: "Character traits"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text:   'Character traits are calculated from your animals DNA. The trait that matches best with the DNA will be displayed on the animals stats and quick info page. The value in brackets behind the trait represents how well the moose matches the given trait.'
                font.pointSize: theme.fontSizeSmall
                wrapMode: Text.WordWrap
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: theme.paddingMedium
                    rightMargin: theme.paddingMedium
                }
            }

            Label {
                text: "Food & Energy"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text:   'Your animals need food. A certain amount of food is spawned automatically at random locations, but you can also place food manually by tapping on the screen. Animals will notice food after a certain time in a certain area around them (if their energy level is below 91%) and eat it. Hungry animals tend to notice food quicker than sated ones. By eating one food-item, the animal gains one energy unit. Animals generally consume more energy while they are moving, but the absolute energy consumption is unique to each animal.'
                font.pointSize: theme.fontSizeSmall
                wrapMode: Text.WordWrap
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: theme.paddingMedium
                    rightMargin: theme.paddingMedium
                }
            }

            Label {
                text: "Mating"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text:   'When two grown up (age > 20) animals stand next to each other, there is a chance that they will mate and create a new animal. This chance depends on both animals energy (higher is better) and age (lower is better, only if high age slowdown is enabled). The new animals DNA is a combination of the parents DNA. After an animal has mated, it can\'t mate again for ~5 minutes.'
                font.pointSize: theme.fontSizeSmall
                wrapMode: Text.WordWrap
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: theme.paddingMedium
                    rightMargin: theme.paddingMedium
                }
            }

            Label {
                text: "Gender"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text:   'There is no such thing as gender in this game. It\'s not just that the population is entirely male/female. The moose simply have no gender. However, in my opinion, only adressing moose in a gender-neutral way in the event messages hurts the overall feeling of the game. Therefore, I decided to add an option in the rename dialog to define if the new name (not the moose itself) is female or male. This makes the event messages sound way better and does not influence anything else.'
                font.pointSize: theme.fontSizeSmall
                wrapMode: Text.WordWrap
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: theme.paddingMedium
                    rightMargin: theme.paddingMedium
                }
            }

            Label {
                text: "Ancestors"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text:   'You can see an animals parents on the animals stats page. A grey moose icon indicates that that animal was spawned artificially or in an early verion of pixl without ancestry logging. You can tap on the two icons to get to the stats page of the parents. This version of the stats page lacks rename/upload actions but will still be accessible once the parent animal is dead.'
                font.pointSize: theme.fontSizeSmall
                wrapMode: Text.WordWrap
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: theme.paddingMedium
                    rightMargin: theme.paddingMedium
                }
            }


            Label {
                text: "Ageing"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text:   'Once an animals age, which can be seen on its stats page, reaches 20, the animal is considered a grown up and is able to mate with other animals. When an animal reaches the age of 90, its movement speed will slowly decline making it harder for this animal to survive. From the age ~80 on, the mating probability of the animal will decrease drastically. This slowdown and mating probability decrease can be disabled in the settings menu.'
                font.pointSize: theme.fontSizeSmall
                wrapMode: Text.WordWrap
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: theme.paddingMedium
                    rightMargin: theme.paddingMedium
                }
            }

            Label {
                text: "Predators"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text:   'Every once in a while, a predator will spawn. These animals are generated randomly and will try to chase moose and kill them. Once a predator has eaten a moose or ran out of energy, it will leave the glade and return to the forest around it. Predator spawning can be disabled in the settings.'
                font.pointSize: theme.fontSizeSmall
                wrapMode: Text.WordWrap
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: theme.paddingMedium
                    rightMargin: theme.paddingMedium
                }
            }

            Label {
                text: "Death"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text:   'Once an animal runs out of energy, it dies. A tombstone will appear at the animals location for a few seconds to indicate the animals death. During that time, you can still see the name of the animal by tapping on the tombstone. If the number of animals drops below three because of a death, the simulation will spawn a new animal.'
                font.pointSize: theme.fontSizeSmall
                wrapMode: Text.WordWrap
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: theme.paddingMedium
                    rightMargin: theme.paddingMedium
                }
            }

            Label {
                text: "Evolution"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text:   'After a few animals die and new ones are born, you\'ll notice that the new animals are stronger/faster/more attentive or less hungry. This is because the animals that find more food or need less energy are more likely to survive and find another animal to mate.'
                font.pointSize: theme.fontSizeSmall
                wrapMode: Text.WordWrap
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: theme.paddingMedium
                    rightMargin: theme.paddingMedium
                }
            }

            Label {
                text: "Multiplayer"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text:   'You can invite moose from your friends phone/tablet over to yours and let them play together by selecting the \'Upload\' option on an animals stats page. Enter the code you receive after uploading the animal on the host device to invite it. Guest animals can\'t mate with local moose and changes (age, death) of guest animals are not synced back to their home device. A \'(g)\' behind the animals name indicates that it is a guest animal. Guest animals can be \'sent home\' from their stats page.'
                font.pointSize: theme.fontSizeSmall
                wrapMode: Text.WordWrap
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: theme.paddingMedium
                    rightMargin: theme.paddingMedium
                }
            }

            Label {
                text: "Event logging"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text:   'Pixl automatically logs certain events like animal birth, death, or predator events. New log messages are displayed on the main screen by default but you can disable this behaviour in the settings menu. To view the full log, go to Info and tap the \'Clipboard\' icon. Tapping on a specific message will display some additional information. You can also clear the log from the settings page.'
                font.pointSize: theme.fontSizeSmall
                wrapMode: Text.WordWrap
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: theme.paddingMedium
                    rightMargin: theme.paddingMedium
                }
            }

            Label {
                text: "Debug Mode"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text:   'You can activate debug mode from the \'Settings\' page. When activated, you can manually spawn/kill animals and the simulation won\'t spawn new animals automatically. Additionally, further information on specific animals will be displayed on their stats page (including a base16 representation of their DNA).'
                font.pointSize: theme.fontSizeSmall
                wrapMode: Text.WordWrap
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: theme.paddingMedium
                    rightMargin: theme.paddingMedium
                }
            }

            Label {
                text: "Feature requests & Contribution"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text:   'A list of all requested features can be found in the github repo. If you would like to add something, just open an issue on github, write me an email write a review. If you would like to contribute to pixl, feel free to fork the code on github and add the features you\'d like to have. Thanks!'
                font.pointSize: theme.fontSizeSmall
                wrapMode: Text.WordWrap
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: theme.paddingMedium
                    rightMargin: theme.paddingMedium
                }
            }

        }
    }

}
