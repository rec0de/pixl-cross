import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import 'qrc:///data.js' as DB

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

    Component.onCompleted: {
        DB.initialize();


        var raw = DB.getallsett();
        var data = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]; // Set values for not yet defined DB data

        for(var i = 0; i < raw.length; i++){
            data[raw[i].uid] = raw[i].value;
        }

        if(data[0] === 1){
            daytime.currentIndex = 1;
            daytime.loaded = true;
        }
        else if(data[0] === 0){
            daytime.currentIndex = 0;
            daytime.loaded = true;
        }
        else{
            daytime.currentIndex = 2;
            daytime.loaded = true;
        }

        if(data[1] === 1){
            debug.checked = true;
        }

        if(data[2] !== 0){
            slowage.checked = true;
        }

        if(data[11] !== 0){
            spawnpred.checked = true;
        }

        if(data[12] !== 0){
            showmsg.checked = true;
        }

        if(data[13] !== 0){
            logorder.checked = true;
        }

        if(data[3] !== -1){
            foodrate.value = data[3];
            foodrate.loaded = true;
        }
        else{
            foodrate.value = 55; // Use default if DB value is not set
            foodrate.loaded = true;
        }
        if(data[10] > 22){
            // Only display story reset if story has been completed
            storyreset.visible = true;
        }
    }

    function updatedaytime(){
        DB.setsett(0, daytime.currentIndex);
    }

    function switchdebug(){
        if(!debug.checked){
            DB.setsett(1, 0); // Deactivate Debug
        }
        else{
            DB.setsett(1, 1); // Activate Debug
        }
    }

    function switchslowage(){
        if(!slowage.checked){
            DB.setsett(2, 0); // Deactivate Slowdown
        }
        else{
            DB.setsett(2, 1); // Activate Slowdown
        }
    }

    function switchpred(){
        if(!spawnpred.checked){
            DB.setsett(11, 0); // Deactivate predator
        }
        else{
            DB.setsett(11, 1); // Activate predators
        }
    }

    function switchmsg(){
        if(!showmsg.checked){
            DB.setsett(12, 0); // Deactivate messages
        }
        else{
            DB.setsett(12, 1); // Activate messages
        }
    }

    function switchlogorder(){
        if(!logorder.checked){
            DB.setsett(13, 0); // Show oldest first
        }
        else{
            DB.setsett(13, 1); // Show newest first
        }
    }


    // Save new foodrate to DB
    function updatefoodrate(){
        DB.setsett(3, foodrate.value);
    }

    Rectangle{
        id: confirmbox
        visible: false
        z: 1000 // Bring to front
        color: theme.highlightColor
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: confirmcol.height + theme.paddingSmall *2

        Column{
            id: confirmcol
            anchors.centerIn: parent

            Label{
                font.pointSize: theme.fontSizeMedium
                color: theme.invertedColor
                anchors.horizontalCenter: parent.horizontalCenter
                text: 'Are you sure?'
            }
            Label{
                id: confirmtitle
                font.pointSize: theme.fontSizeSmall
                color: theme.invertedColor
                anchors.horizontalCenter: parent.horizontalCenter
                text: 'All your progress will be lost.'
            }
            Label{
                id: confirminfo
                font.pointSize: theme.fontSizeSmall
                color: theme.invertedColor
                anchors.horizontalCenter: parent.horizontalCenter
                text: 'Please type \'reset\' below to reset.'
            }
            TextField{
                anchors.topMargin: theme.paddingMedium
                id: confirmtext
                placeholderText: 'Type here'
                font.pointSize: theme.fontSizeMedium
                width: confirminfo.width
                anchors.horizontalCenter: parent.horizontalCenter
                style: TextFieldStyle {
                    textColor: theme.invertedColor
                    placeholderTextColor: theme.invertedColor
                    background: Rectangle {
                        color: 'transparent'
                        border.width: 2
                        radius: 5
                        border.color: theme.invertedColor
                    }
                }
                onAccepted: {
                    if(confirmtext.text.toLowerCase() === 'reset'){
                        confirmtitle.text = 'Stopping app...';
                        DB.hardreset();
                        confirmreset.start();
                        quitter.start();
                    }
                    else{
                        confirmtitle.text = 'Reset cancelled.';
                        confirmreset.start();
                    }
                }
            }

            Rectangle{
                anchors.horizontalCenter: parent.horizontalCenter
                width: confirminfo.width
                height: resetbutton.height + theme.paddingMedium
                color: 'transparent'

                Label{
                    id: resetbutton
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: 'Reset'
                    font.pointSize: theme.fontSizeMedium
                    font.underline: true
                    color: theme.invertedColor

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            if(confirmtext.text.toLowerCase() === 'reset'){
                                confirmtitle.text = 'Stopping app...';
                                DB.hardreset();
                                confirmreset.start();
                                quitter.start();
                            }
                            else{
                                confirmtitle.text = 'Reset cancelled.';
                                confirmreset.start();
                            }
                        }
                    }
                }
                Label{
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: 'Cancel'
                    font.pointSize: theme.fontSizeMedium
                    font.underline: true
                    color: theme.invertedColor
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            confirmtitle.text = 'Reset cancelled.';
                            confirmreset.start()
                        }
                    }
                }
            }
        }

        Timer{
            id: confirmreset
            interval: 1000
            running: false
            repeat: false
            onTriggered: {
                confirmbox.visible = false;
                confirmtitle.text = 'All your progress will be lost.';
            }
        }

        Timer{
            id: quitter
            interval: 900
            running: false
            repeat: false
            onTriggered: {
                Qt.quit();
            }
        }

    }

    Rectangle{
        id: logconfirmbox
        visible: false
        z: 1000 // Bring to front
        color: theme.highlightColor
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: logconfirmcol.height + theme.paddingSmall *2

        Column{
            id: logconfirmcol
            anchors.centerIn: parent

            Label{
                font.pointSize: theme.fontSizeMedium
                color: theme.invertedColor
                anchors.horizontalCenter: parent.horizontalCenter
                text: 'Are you sure?'
            }
            Label{
                id: logconfirmtitle
                font.pointSize: theme.fontSizeSmall
                color: theme.invertedColor
                anchors.horizontalCenter: parent.horizontalCenter
                text: 'All log messages will be lost.'
            }
            Label{
                id: logconfirminfo
                font.pointSize: theme.fontSizeSmall
                color: theme.invertedColor
                anchors.horizontalCenter: parent.horizontalCenter
                text: 'Please type \'reset\' below to reset.'
            }
            TextField{
                anchors.topMargin: theme.paddingMedium
                id: logconfirmtext
                placeholderText: 'Type here'
                font.pointSize: theme.fontSizeMedium
                width: logconfirminfo.width
                anchors.horizontalCenter: parent.horizontalCenter
                style: TextFieldStyle {
                    textColor: theme.invertedColor
                    placeholderTextColor: theme.invertedColor
                    background: Rectangle {
                        color: 'transparent'
                        border.width: 2
                        radius: 5
                        border.color: theme.invertedColor
                    }
                }
                onAccepted: {
                    if(logconfirmtext.text.toLowerCase() === 'reset'){
                        logconfirmtitle.text = 'Resetting...';
                        DB.log_clear();
                        logconfirmreset.start();
                    }
                    else{
                        logconfirmtitle.text = 'Reset cancelled.';
                        logconfirmreset.start();
                    }
                }
            }

            Rectangle{
                anchors.horizontalCenter: parent.horizontalCenter
                width: logconfirminfo.width
                height: logresetbutton.height + theme.paddingMedium
                color: 'transparent'

                Label{
                    id: logresetbutton
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: 'Reset'
                    font.pointSize: theme.fontSizeMedium
                    font.underline: true
                    color: theme.invertedColor

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            if(logconfirmtext.text.toLowerCase() === 'reset'){
                                logconfirmtitle.text = 'Resetting...';
                                DB.log_clear();
                                logconfirmreset.start();
                            }
                            else{
                                logconfirmtitle.text = 'Reset cancelled.';
                                logconfirmreset.start();
                            }
                        }
                    }
                }
                Label{
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: 'Cancel'
                    font.pointSize: theme.fontSizeMedium
                    font.underline: true
                    color: theme.invertedColor

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            logconfirmtitle.text = 'Reset cancelled.';
                            logconfirmreset.start()
                        }
                    }
                }
            }
        }

        Timer{
            id: logconfirmreset
            interval: 1000
            running: false
            repeat: false
            onTriggered: {
                logconfirmbox.visible = false;
                logconfirmtitle.text = 'All log messages will be lost.';
            }
        }

    }

    ToolBar {
        id: header
        z: 3
        RowLayout {
            anchors.fill: parent
            anchors.margins: spacing

            Label {
                text: '< Settings'
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

            Label {
                text: " " // Ugly Spacer
                font.pointSize: theme.fontSizeSmall
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text: "General"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Rectangle{
                height: slowage.height
                width: parent.width - theme.paddingSmall*2
                anchors.horizontalCenter: parent.horizontalCenter
                color: 'transparent'

                Label{
                    anchors.top: parent.top
                    anchors.left: parent.left
                    text: 'Slow down old animals'
                    font.pointSize: theme.fontSizeSmall
                }

                Switch {
                    id: slowage
                    anchors.top: parent.top
                    anchors.right: parent.right
                    onCheckedChanged:{
                        switchslowage()
                    }
                }
            }

            Rectangle{
                height: spawnpred.height
                width: parent.width - theme.paddingSmall*2
                anchors.horizontalCenter: parent.horizontalCenter
                color: 'transparent'

                Label{
                    anchors.top: parent.top
                    anchors.left: parent.left
                    text: 'Spawn predators'
                    font.pointSize: theme.fontSizeSmall
                }

                Switch {
                    id: spawnpred
                    anchors.top: parent.top
                    anchors.right: parent.right
                    onCheckedChanged:{
                        switchpred()
                    }
                }
            }

            Rectangle{
                height: showmsg.height
                width: parent.width - theme.paddingSmall*2
                anchors.horizontalCenter: parent.horizontalCenter
                color: 'transparent'

                Label{
                    anchors.top: parent.top
                    anchors.left: parent.left
                    text: 'Log messages on main screen'
                    font.pointSize: theme.fontSizeSmall
                }

                Switch {
                    id: showmsg
                    anchors.top: parent.top
                    anchors.right: parent.right
                    onCheckedChanged:{
                        switchmsg()
                    }
                }
            }

            Rectangle{
                height: logorder.height
                width: parent.width - theme.paddingSmall*2
                anchors.horizontalCenter: parent.horizontalCenter
                color: 'transparent'

                Label{
                    anchors.top: parent.top
                    anchors.left: parent.left
                    text: 'Show latest logs first'
                    font.pointSize: theme.fontSizeSmall
                }

                Switch {
                    id: logorder
                    anchors.top: parent.top
                    anchors.right: parent.right
                    onCheckedChanged:{
                        switchlogorder()
                    }
                }
            }

            Rectangle{
                height: daytime.height
                width: parent.width - theme.paddingSmall*2
                anchors.horizontalCenter: parent.horizontalCenter
                color: 'transparent'

                Label{
                    anchors.top: parent.top
                    anchors.left: parent.left
                    text: 'Daytime'
                    font.pointSize: theme.fontSizeSmall
                }

                ComboBox {
                    id: daytime
                    anchors.right: parent.right
                    property bool loaded: false // Avoid feedback loop when setting daytime

                    model: ListModel {
                        ListElement { text: "Day" }
                        ListElement { text: "Night" }
                        ListElement { text: "Cycle" }
                    }
                    onCurrentIndexChanged: {
                        if(loaded){
                            updatedaytime();
                        }
                    }
                }
            }


            Slider {
                id: foodrate
                width: parent.width - 2*theme.paddingSmall
                anchors.horizontalCenter: parent.horizontalCenter
                updateValueWhileDragging: false
                minimumValue: 20
                maximumValue: 150
                stepSize: 1
                property bool loaded: false
                onValueChanged: {
                    if(foodrate.loaded){ // Avoid feedback loop when setting value
                        updatefoodrate()
                    }
                }
            }

            Label {
                text: 'Food spawn rate (lower = more)'
                font.pointSize: theme.fontSizeSmall
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text: "Debug"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Rectangle{
                height: debug.height
                width: parent.width - theme.paddingSmall*2
                anchors.horizontalCenter: parent.horizontalCenter
                color: 'transparent'

                Label{
                    anchors.top: parent.top
                    anchors.left: parent.left
                    text: 'Debug mode'
                    font.pointSize: theme.fontSizeSmall
                }

                Switch {
                    id: debug
                    anchors.top: parent.top
                    anchors.right: parent.right
                    onCheckedChanged:{
                        switchdebug()
                    }
                }
            }

            Button {
               text: "Restart Story"
               id: storyreset
               visible: false
               anchors.horizontalCenter: parent.horizontalCenter
               onClicked:{
                    DB.setsett(10, 0);
                    storyreset.visible = false;
               }
            }

            Button {
               text: "Reset Log"
               anchors.horizontalCenter: parent.horizontalCenter
               onClicked:{
                    logconfirmbox.visible = true;
               }
            }

            Button {
               text: "Reset Game"
               anchors.horizontalCenter: parent.horizontalCenter
               onClicked:{
                   confirmbox.visible = true;
               }
            }

        }
    }

}
