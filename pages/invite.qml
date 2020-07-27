import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import 'qrc:///data.js' as DB

Rectangle {
    id: page
    property string code: ''

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

    function updatemessage(msg){
        msgtext.text = msg;
        message.visible = true;
    }

    function load(code) {
        if(code === ''){
            updatemessage('Error: Please enter code');
            return
        }

        var url = 'https://rec0de.net/pixl/getanimal.php?code='+code;

        var xhr = new XMLHttpRequest();
        xhr.timeout = 1000;

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                console.log('status', xhr.status, xhr.statusText)
                //console.log('response', xhr.responseText)
                if(xhr.status >= 200 && xhr.status < 300) {

                    var text = xhr.responseText;

                    //Escaping content fetched from web to prevent script injections
                    var patt1 = /(<|>|\{|\}|\[|\]|\\)/g;
                    text = text.replace(patt1, '');

                    var array = text.split('|')
                    if(array[0] === '' && array[1] === '' && array[2] === ''){
                        updatemessage('Error: Moose doesn\'t exist.');
                    }
                    else{
                        var id = DB.getsett(7);
                        if(id === '-1'){
                            id = 0;
                        }

                        // Count animals
                        if(DB.getall !== false && DB.getnonlocal() !== false){
                            var count = DB.getall().length + DB.getnonlocal().length;
                        }
                        else if(DB.getall !== false){
                            count = DB.getall().length;
                        }
                        else if(DB.getnonlocal() !== false){
                            count = DB.getnonlocal().length;
                        }
                        else{
                            count = 0;
                        }

                        // Upper limit for population
                        if(count < 31){
                            DB.addnonlocal(array[2], array[0], array[1], id);
                            DB.setsett(7, id+1);
                            updatemessage('Imported '+array[0]);
                            pageclose.start();
                        }
                        else{
                            updatemessage('Error: Too many moose. ('+count+')')
                        }
                    }
                }
                else {
                    updatemessage('Error: Connection failed.');
                }
            }
        }

        xhr.ontimeout = function() {
            updatemessage('Error: Request timed out.');
        }

        xhr.open('GET', url, true);
        xhr.setRequestHeader("User-Agent", "Mozilla/5.0 (compatible; Pixl app for Android)");
        xhr.send();
    }

    ToolBar {
        id: header
        z: 3
        RowLayout {
            anchors.fill: parent
            anchors.margins: spacing

            Label {
                text: '< Invite Animal'
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

            Label{
                font.pointSize: theme.fontSizeMedium
                wrapMode: Text.WordWrap
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: theme.paddingMedium
                    rightMargin: theme.paddingMedium
                }
                text: 'Please enter the guest animal\'s unique code'
            }

            TextField{
                id: codeField
                anchors.horizontalCenter: parent.horizontalCenter
                focus: true
                onAccepted: {
                    load(codeField.text);
                    focus = false;
                }
            }

            Label {
                text: "Invite"
                font.pointSize: theme.fontSizeSmall
                color: theme.primaryColor
                font.underline: true
                anchors.horizontalCenter: parent.horizontalCenter
                MouseArea{
                    anchors.fill: parent
                    onClicked: load(codeField.text)
                }
            }
        }
    }

    Timer{
        id: pageclose
        interval: 900
        running: false
        repeat: false
        onTriggered: {
            pageStack.pop();
        }
    }


    Rectangle {
        id: message
        visible: false
        anchors.centerIn: parent
        width: page.width
        height: msgtext.height + theme.paddingMedium * 2
        color: theme.highlightColor
        z: 1000
        Label{
            id: msgtext
            visible: parent.visible
            anchors.centerIn: parent
            text: 'Message'
            font.pointSize: theme.fontSizeLarge
            color: theme.invertedColor
        }
        MouseArea {
            anchors.fill : parent
            onClicked: parent.visible = false
        }
    }
}
