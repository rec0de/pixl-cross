import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import 'qrc:///data.js' as DB



Rectangle {
    id: page
    property var log

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

        var descending;

        // Get log order setting
        if(DB.getsett(13) != 0){
            descending = true;
        }
        else{
            descending = false;
        }

        // Load log from DB
        page.log = DB.log_get(descending);

        for(var i = 0; i < page.log.length; i++){
            listModel.append({"name": page.log[i].val, "info": page.log[i].info, "time": page.log[i].time, "mid": page.log[i].mooseid});
        }
    }

    function popup(time, text, animal){ // Shows info popup
        infobox.visible = true;
        infotime.text = gettime(time);
        infotitle.text = text;
        infobox.animal = animal;
        var data = DB.ancestors_getdata(animal);
        if(data !== false){
            infobutton.text = 'About '+data.name;
        }
        else{
            infobutton.visible = false;
        }
    }

    function gettime(time){
        var diff = Math.round((Date.now() - time)/1000);
        var res;
        if(diff < 13){
            res = 'Just now';
        }
        else if(diff < 60){
            res = diff + ' seconds ago';
        }
        else if(diff < 60*60){
            diff = Math.round(diff/60);
            res = (diff === 1) ? (diff + ' minute ago') : (diff + ' minutes ago');
        }
        else if(diff < 60*60*24){
            diff = Math.round(diff/(60*60));
            res = (diff === 1) ? (diff + ' hour ago') : (diff + ' hours ago');
        }
        else if(diff < 60*60*24*30.5){
            diff = Math.round(diff/(60*60*24));
            res = (diff === 1) ? (diff + ' day ago') : (diff + ' days ago');
        }
        else if(diff < 60*60*24*365){
            diff = Math.round(diff/(60*60*24*30.5));
            res = (diff === 1) ? (diff + ' month ago') : (diff + ' months ago');
        }
        else {
            diff = Math.round(diff/(60*60*24*365));
            res = (diff === 1) ? (diff + ' year ago') : (diff + ' years ago');
        }

        return res;
    }


    Rectangle{
        id: infobox
        visible: false
        z: 1000 // Bring to front
        color: theme.highlightColor
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: infocol.height + theme.paddingSmall *2
        property int animal: -1

        onWidthChanged: {
            if(width > Math.round(170 * Screen.pixelDensity)){
                infocol.width = Math.round(170 * Screen.pixelDensity);
            }
            else{
                infocol.width = width;
            }
        }

        MouseArea{
            anchors.fill: parent
            onClicked:{
                infobox.visible = false;
            }
        }

        Column{
            id: infocol
            anchors.centerIn: parent
            width: parent.width

            Label{
                font.pointSize: theme.fontSizeMedium
                color: theme.invertedColor
                anchors.horizontalCenter: parent.horizontalCenter
                text: 'Info'
            }
            Label{
                id: infotitle
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                font.pointSize: theme.fontSizeSmall
                color: theme.invertedColor
                anchors.horizontalCenter: parent.horizontalCenter
                text: 'Oops. Something went wrong.'
            }
            Label{
                id: infobutton
                visible: (infobox.animal && infobox.animal !== -1) ? true : false
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: theme.fontSizeSmall
                font.underline: true
                color: theme.invertedColor
                anchors.horizontalCenter: parent.horizontalCenter
                text: 'About Moose'
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(infobox.animal && infobox.animal !== -1){
                            pageStack.push(Qt.resolvedUrl("aboutanimal.qml"), {local: true, id: infobox.animal});
                        }
                    }
                }
            }

            Rectangle{
                // spacer
                width: parent.width
                height: theme.paddingSmall
                color: 'transparent'
            }

            Label{
                id: infotime
                font.pointSize: theme.fontSizeSmall * 0.7
                color: theme.invertedColor
                anchors.horizontalCenter: parent.horizontalCenter
                text: 'Some time ago.'
            }

        }
    }


    ListModel {
         id: listModel
    }

    ToolBar {
        id: header
        z: 3
        RowLayout {
            anchors.fill: parent
            anchors.margins: spacing

            Label {
                text: '< Event Log'
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

    onWidthChanged: {
        if(width > Math.round(170 * Screen.pixelDensity)){
            listView.width = Math.round(170 * Screen.pixelDensity);
        }
        else{
            listView.width = width;
        }
    }

    ListView {
        id: listView
        model: listModel
        width: parent.width
        height: parent.height - header.height
        y: header.height
        z: 1
        anchors.horizontalCenter: parent.horizontalCenter

        delegate: Item {
            id: delegate
            width: parent.width
            height: logtext.height + Screen.pixelDensity * 3

            Label {
                id: logtext
                text: name
                font.pointSize: theme.fontSizeSmall
                wrapMode: Text.WordWrap
                width: parent.width - 3
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: theme.paddingMedium
                    rightMargin: theme.paddingMedium
                }
                color: theme.primaryColor
            }

            MouseArea{
                anchors.fill: parent
                onClicked:{
                    if(!mid){
                        mid = -1;
                    }

                    popup(time, name, mid);
                }
            } 
        }
    }
}
