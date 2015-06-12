import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import 'qrc:///data.js' as DB



Rectangle {
    id: page
    property var animals
    property var guests

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
                text: '< Animal list'
                font.pointSize: theme.fontSizeLarge
                MouseArea{
                    anchors.fill: parent
                    onClicked: pageStack.pop()
                }
            }

            Item { Layout.fillWidth: true }

            Row{
                anchors.verticalCenter: parent.verticalCenter

                ToolButton{
                    Image {
                        source: 'qrc:///img/log.png'
                        height: parent.height
                        width: parent.width
                    }
                    height: header.height * 0.7
                    width: header.height * 0.7
                    onClicked:{
                        pageStack.push(Qt.resolvedUrl("qrc:///pages/logview.qml"))
                    }
                }

                ToolButton{
                    Image {
                        source: 'qrc:///img/settings.png'
                        height: parent.height
                        width: parent.width
                    }
                    height: header.height * 0.7
                    width: header.height * 0.7
                    onClicked:{
                        pageStack.push(Qt.resolvedUrl("qrc:///pages/settings.qml"))
                    }
                }

                ToolButton{
                    Image {
                        source: 'qrc:///img/info.png'
                        height: parent.height
                        width: parent.width
                    }
                    height: header.height * 0.7
                    width: header.height * 0.7
                    onClicked:{
                        pageStack.push(Qt.resolvedUrl("qrc:///pages/about2.qml"))
                    }
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

    Component.onCompleted: {
        DB.initialize();


        // List local animals first
        page.animals = DB.getall();

        for(var i = 0; i < page.animals.length; i++){
            animalModel.append({"name": page.animals[i].name, "age": page.animals[i].age, "dna": page.animals[i].dna, "animal": true, "local": true, "id": page.animals[i].id})
        }

        // List non-local animals
        page.guests = DB.getnonlocal();

        for(var i = 0; i < page.guests.length; i++){
            animalModel.append({"name": page.guests[i].name, "age": page.guests[i].age, "dna": page.guests[i].dna, "animal": true, "local": false, "id": page.guests[i].id})
        }


        // Add Invite animal element
        animalModel.append({"name": 'Invite animal...', "animal": false, "local": true})
    }


    function refresh(){
        // Reload all names

        // List local animals
        page.animals = DB.getall();
        animalModel.clear();

        for(var i = 0; i < page.animals.length; i++){
            animalModel.append({"name": page.animals[i].name, "age": page.animals[i].age, "dna": page.animals[i].dna, "animal": true, "local": true, "id": page.animals[i].id})
        }

        // List non-local animals
        page.guests = DB.getnonlocal();

        for(var i = 0; i < page.guests.length; i++){
            animalModel.append({"name": page.guests[i].name, "age": page.guests[i].age, "dna": page.guests[i].dna, "animal": true, "local": false, "id": page.guests[i].id})
        }

        // Invite animal element
        animalModel.append({"name": 'Invite animal...', "animal": false, "local": true})

    }

    ListModel {
         id: animalModel
    }

    Timer {
        id: refresher
        interval: 4000
        running: Qt.application.active
        repeat: true
        onTriggered: refresh()
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
        model: animalModel
        width: parent.width
        height: parent.height - header.height
        y: header.height
        z: 1
        anchors.horizontalCenter: parent.horizontalCenter

        delegate: Item {
            id: delegate
            height: row.height - row.border.width
            width: parent.width + row.border.width * 2
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle{
                id: row
                color: 'transparent'
                radius: 5
                border.width: 5
                border.color: theme.highlightColor
                height: 1.7 * listlabel.height
                width: parent.width

                Image{
                    source: !animal ? 'qrc:///img/moose_sw.png' : 'qrc:///img/moose'+(parseInt(dna.substr(2, 2), 2) + 1)+'.png'
                    visible: animal
                    anchors.left: parent.left
                    anchors.leftMargin: theme.paddingMedium
                    anchors.verticalCenter: parent.verticalCenter
                }

                Label {
                    id: listlabel
                    text: local ? name : name + ' (g)'
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: theme.primaryColor
                    font.pointSize: theme.fontSizeLarge

                }

            }

            MouseArea{
                anchors.fill: parent
                onClicked:{
                    if(animal){
                        pageStack.push(Qt.resolvedUrl("qrc:///pages/aboutanimal.qml"), {name: name, dna: dna, age: age, local: local, id: id});
                    }
                    else{
                        pageStack.push(Qt.resolvedUrl("qrc:///pages/invite.qml"))
                    }
                }
            }
        }
    }
}
