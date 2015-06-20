import QtQuick 2.0
import QtQuick.Particles 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 1.2


Rectangle {
    id: page

    property int speed: 5 // Movement speed
    property int offset: rect.height - background.height
    property real gravity: 0.7 // Downward accelleration per tick

    Item{
        id: theme
        property int paddingSmall: (5 / 2) * Screen.pixelDensity
        property int paddingMedium: (15 / 4) * Screen.pixelDensity
        property int paddingLarge: 4 * Screen.pixelDensity
        property int fontSizeSmall: 16
        property int fontSizeMedium: 20
        property int fontSizeLarge: 24
        property int fontSizeExtraLarge: 32
        property int itemSizeLarge: 30
        property color primaryColor: '#000000'
        property color highlightColor: '#8888ff'
        property color invertedColor: '#ffffff'
        property color headerColor: 'lightgray'
    }

    // Main function
    function tick(){

        // Move background layers
        background.x = (background.x - page.speed) % gamepix(300);

        // Apply gravity to player
        player.y = player.y - player.vspeed;
        player.vspeed = player.vspeed - page.gravity;

        // Collision detection
        if(player.y < 0){
            player.y = 0;
        }
        else if(player.y > (page.height - player.height)){
            player.y = (page.height - player.height);
        }
    }

    // Converts game/graphic pixels to display pixels
    function gamepix(num){
        return Math.floor(rect.height/background.sourceSize.height)*num;
    }

    // Returns y value for an object n game pixels from the bottom given the source height
    function pixfrombottom(n, sheight){
        return rect.height- gamepix(n) - gamepix(sheight);
    }

    FontLoader { id: pixels; source: "qrc:///img/pixelmix.ttf" }

    Timer {
        id: ticker
        interval: 35
        running: Qt.ApplicationActive
        repeat: true
        onTriggered: tick()
    }

    // Solid color background
    Rectangle {
        id: rect
        width: parent.width
        height: parent.height
        color: '#84b331'
        Behavior on color {
            ColorAnimation {duration: 700 }
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                player.vspeed = 10;
            }
        }
    }

    Image {
        x: 0
        y: page.offset
        id: background
        source: "qrc:///img/eegg_back.png"
        smooth: false
        opacity: 1
        width: gamepix(sourceSize.width)
        height: gamepix(sourceSize.height)
    }


    ParticleSystem{
        anchors.fill: parent
        z: 6

        ImageParticle{
            source: 'qrc:///img/moose_eegg.png'
            rotation: 360
            alphaVariation: 0.4
            colorVariation: 1
            entryEffect: ImageParticle.Fade

            smooth: false
            z: 1
        }

        Gravity{
            anchors.fill: parent
            angle: 90
            magnitude: 70
        }

        Emitter{
            id: emitter
            enabled: Qt.ApplicationActive
            height: gamepix(1)
            width: gamepix(1)
            y: player.y + gamepix(player.sourceSize.height * 2)
            x: player.x
            size: gamepix(4)
            smooth: false
            lifeSpan: 4000
            velocity: AngleDirection{
                angle: 200
                angleVariation: 30
                magnitude: 230
            }

        }
    }

    // Playable character
    Image {
        id: player
        x: 4*(page.width / 5) - width
        y: pixfrombottom(8, player.sourceSize.height * 2)
        z: 7
        source: "qrc:///img/eegg5.png"
        smooth: false
        opacity: 1
        width: gamepix(sourceSize.width * 2)
        height: gamepix(sourceSize.height * 2)

        property real vspeed: 0
    }

    Label{
        text: 'Pixl'
        id: title
        z: 10
        color: theme.invertedColor
        anchors.left: rect.left
        anchors.top: rect.top
        anchors.leftMargin: theme.paddingLarge
        anchors.topMargin: theme.paddingLarge
        font.pointSize: theme.fontSizeExtraLarge * 2
        font.family: pixels.name
    }

    Label{
        text: 'Thanks for playing.'
        z: 10
        color: theme.invertedColor
        anchors.left: rect.left
        anchors.top: title.bottom
        anchors.leftMargin: theme.paddingLarge
        anchors.topMargin: theme.paddingMedium
        font.pointSize: theme.fontSizeSmall
        font.family: pixels.name
    }
}
