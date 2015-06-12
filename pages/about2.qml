import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
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
        RowLayout {
            anchors.fill: parent
            anchors.margins: spacing

            Label {
                text: '< About Pixl'
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

    function getscale() {
        var density = Screen.pixelDensity;

        if(45 / density < 2.26){
            return 2.5;
        }
        if(45 / density < 3.1){
            return 2;
        }
        else if(45 / density < 4.1){
            return 1.5;
        }
        else{
            return 1;
        }
    }

    // Easter Egg
    Rectangle {
        id: eegg
        visible: thanks.clickcount > 7
        anchors.centerIn: parent
        width: page.width
        height: eeggcol.height + theme.paddingMedium * 2
        color: theme.highlightColor
        z: 1000

        Column{
            id: eeggcol
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Image{
                source: 'qrc:///img/eegg4.png'
                smooth: false
                height: sourceSize.height * 4 * getscale()
                width: sourceSize.width * 4 * getscale()
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label{
                id: msgtext
                visible: parent.visible
                anchors.horizontalCenter: parent.horizontalCenter
                text: 'Moo.'
                font.pointSize: theme.fontSizeLarge
                color: theme.invertedColor
            }
        }
        MouseArea {
            anchors.fill : parent
            onClicked: thanks.clickcount = 0
        }
    }

    Flickable {
        height: parent.height - header.height
        y: header.height
        width: parent.width
        contentHeight: col.height + 20
        id: flick
        z: 1

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
            spacing: theme.paddingMedium
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                text: " " // Ugly Spacer
                font.pointSize: theme.fontSizeSmall
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text: "License"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text: "GPL v3"
                font.pointSize: theme.fontSizeSmall
                anchors.horizontalCenter: parent.horizontalCenter
                MouseArea {
                    id : licenseMouseArea
                    anchors.fill : parent
                    onClicked: Qt.openUrlExternally("http://choosealicense.com/licenses/gpl-v3/")
                }
            }

            Label {
                text: "Made by"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text: "@rec0denet"
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: theme.fontSizeSmall
            }

            Label {
                text: "Source"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text: "github.com/rec0de/pixl-cross"
                font.underline: true;
                font.pointSize: theme.fontSizeSmall
                anchors.horizontalCenter: parent.horizontalCenter
                MouseArea {
                    id : sourceMouseArea
                    anchors.fill : parent
                    onClicked: Qt.openUrlExternally("https://github.com/rec0de/pixl-cross")
                }
            }


            Label {
                text: "Contact"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text: "mail@rec0de.net"
                font.pointSize: theme.fontSizeSmall
                anchors.horizontalCenter: parent.horizontalCenter
                MouseArea {
                    id : contactMouseArea
                    anchors.fill : parent
                    onClicked: Qt.openUrlExternally("mailto:mail@rec0de.net")
                }
            }

            Label {
                text: "Privacy"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                id: privacy
                text:   'By default, pixl does not collect or send any data. However, if you decide to use the Multiplayer/Invite-a-moose feature, the guest animals data will be uploaded to the pixl server and downloaded by the host. During this process, your IP might be logged by our service provider.'
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
                text: "Portation"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                id: port
                text:   'This app is the cross-platform/android port of the original pixl v0.2.2 for SailfishOS. The ported version might contain more bugs / UI flaws that the original version. If you want to get the best playing experience & most recent updates, I highly recommend using a SailfishOS device.'
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
                text: "About me"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                id: aboutme
                text:   'I develop these apps as a hobby. Therefore, please don\'t expect them to work perfectly. If you like what I\'m doing, please consider liking / commenting the app. Thanks!'
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
                text: "Thanks"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                id: thanks
                text: 'Font by astramat.com<br>Database derived from \'noto\' by leszek.<br>Thanks to gukke, AL13N, KAOS, Eli, my Android testers and all the others who found bugs and shared their ideas.<br>Inspired by \'Disco Zoo\' and \'A dark room\'.<br>Made with QtCreator<br>Toolbar icons by iconmonstr.com<br> Thanks to all of you!'
                font.pointSize: theme.fontSizeSmall
                wrapMode: Text.WordWrap
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: theme.paddingMedium
                    rightMargin: theme.paddingMedium
                }
                property int clickcount: 0

                MouseArea{
                    anchors.fill: parent
                    onClicked: parent.clickcount = parent.clickcount + 1
                }
            }
        }
    }

}
