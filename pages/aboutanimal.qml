import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import 'qrc:///data.js' as DB

Rectangle {
    id: page
    property string dna
    property string name
    property string newname
    property bool local
    property int age
    property int id
    property int namegender
    property var specieslist: ['Common Moose', 'Dark Moose', 'Red Moose', 'Beige Moose']
    property int species
    property bool debug
    property bool ancestor: false;

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

    Component.onCompleted: {
        DB.initialize();

        // Check for debug mode
        if(DB.getsett(1) === 1){
            page.debug = true;
        }
        else{
            page.debug = false;
        }

        // Attempt to get data from ancestors DB
        if(local){
            var data = DB.ancestors_getdata(page.id);
            if(data !== false){
                page.name = data.name;
                page.dna = data.dna;
            }
        }

        var dna = page.dna;
        var basepath = '../img/moose';
        var color = parseInt(dna.substr(2, 2), 2) + 1;
        page.species = color - 1;
        image.source = basepath + color + '.png';
        speclabel.text = page.specieslist[species];

        // Get animal parents
        var parents = DB.ancestors_get(id);
        parentnamea.text = parents[0];
        parentnameb.text = parents[2];
        parentnamea.dna = parents[1];
        parentnameb.dna = parents[3];
        parentnamea.id = parents[4];
        parentnameb.id = parents[5];

        if(parents[1] === '0'){
            // Display missing moose graphic
            parentimagea.source = 'qrc:///img/moose_sw.png';
        }
        else{
            parentimagea.source = 'qrc:///img/moose' + (parseInt(parents[1].substr(2, 2), 2) + 1) + '.png';
        }

        if(parents[3] === '0'){
            // Display missing moose graphic
            parentimagea.source = 'qrc:///img/moose_sw.png';
        }
        else{
            parentimageb.source = 'qrc:///img/moose' + (parseInt(parents[3].substr(2, 2), 2) + 1) + '.png';
        }

        // Get age from DB
        if(local){
            if(DB.getage(page.id) !== false){
                page.age = Math.round(DB.getage(id)/400);
                agetext.text = page.age;
            }
            else{
                agetext.text = 'Deceased';
                page.ancestor = true;
            }
        }
    }

    function pers1(){
        var dna = page.dna;
        var energystill = parseInt(dna.substr(20, 3), 2)/8;
        var minspeed = parseInt(dna.substr(27, 3), 2)/8;
        var maxspeed = parseInt(dna.substr(30, 3), 2)/8;
        var energymoving = parseInt(dna.substr(24, 4), 2)/16;
        var maxenergy = parseInt(dna.substr(17, 3), 2)/8;

        var hungry = (1 + energystill)*(1 + energymoving) - maxspeed*1.2; // Between 0 and 4
        var fast = (1 + minspeed)*(1 + maxspeed) - energymoving/2.4; // Between 0 and 4
        var untiring = (2 - hungry/2)*(1+maxenergy); // Between 0 and 4

        if(hungry > fast && hungry > untiring){
            return 'Hungry ('+Math.round((hungry/4)*100)+'%)';
        }
        else if(fast >= hungry && fast >= untiring){
            return 'Fast ('+Math.round((fast/4)*100)+'%)';
        }
        else{
            return 'Untiring ('+Math.round((untiring/4)*100)+'%)';
        }
    }
    function pers2(){
        var dna = page.dna;
        var viewarea = parseInt(dna.substr(4, 3), 2)/8;
        var movingchange = parseInt(dna.substr(7, 3), 2)/8;
        var stillchange = parseInt(dna.substr(10, 3), 2)/8;
        var directionchange = parseInt(dna.substr(13, 4), 2)/16;
        var searchingduration = parseInt(dna.substr(36, 4), 2)/16;

        var lazy = movingchange*4 - stillchange*1.2;
        var clever = viewarea*1.8 + searchingduration*1.8;
        var hyperactive = (stillchange*2)+(directionchange*2) - movingchange;

        if(lazy > clever && lazy > hyperactive){
            return 'Lazy ('+Math.round((lazy/4)*100)+'%)';
        }
        else if(clever >= lazy && clever >= hyperactive){
            return 'Clever ('+Math.round((clever/4)*100)+'%)';
        }
        else{
            return 'Hyperactive ('+Math.round((hyperactive/4)*100)+'%)';
        }

    }

    function pers3(){ // Social character trait
        var dna = page.dna;
        var socialtrait = parseInt(dna.substr(0, 2), 2);
        if(socialtrait === 0){
            return 'Caring';
        }
        else if(socialtrait === 1){
            return 'Egoist';
        }
        else if(socialtrait === 2){
            return 'Communicative';
        }
        else if(socialtrait === 3){
            return 'Solitary';
        }
    }

    function updatemessage(msg){
        msgtext.text = msg;
        message.visible = true;
    }

    function upload() {
        var url = 'https://rec0de.net/pixl/upload.php?dna='+page.dna+'&name='+page.name+'&age='+(page.age*400);

        var xhr = new XMLHttpRequest();
        xhr.timeout = 1000;

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                console.log('status', xhr.status, xhr.statusText)
                console.log('response', xhr.responseText)
                if(xhr.status >= 200 && xhr.status < 300) {

                    var text = xhr.responseText;

                    //Escaping content fetched from web to prevent script injections
                    var patt1 = /(<|>|\{|\}|\[|\]|\\)/g;
                    text = text.replace(patt1, '');

                    if(text === 'E1'){
                        updatemessage('Error: Corrupted DNA');
                    }
                    else if(text === 'E2'){
                        updatemessage('Error: Name too long');
                    }
                    else if(text.length < 6){
                        updatemessage('Done! Code: '+text);
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

    Rectangle{
        id: dialog
        visible: false
        z: 1000 // Bring to front
        color: theme.highlightColor
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: dialog_col.height + theme.paddingSmall *2

        Column{
            id: dialog_col
            anchors.centerIn: parent

            Label{
                font.pointSize: theme.fontSizeMedium
                color: theme.invertedColor
                anchors.horizontalCenter: parent.horizontalCenter
                text: 'Rename animal'
            }
            Label{
                id: dialog_title
                font.pointSize: theme.fontSizeSmall
                color: theme.invertedColor
                anchors.horizontalCenter: parent.horizontalCenter
                text: 'Please choose a new name for your moose'
            }
            TextField{
                anchors.topMargin: theme.paddingMedium
                id: dialog_newname
                placeholderText: page.name
                font.pointSize: theme.fontSizeMedium
                width: dialog_title.width
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
                    focus: false;
                }
            }

            Rectangle{
                height: dialog_namegender.height
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                color: 'transparent'

                Label{
                    anchors.top: parent.top
                    anchors.left: parent.left
                    text: 'Use these pronouns:'
                    font.pointSize: theme.fontSizeSmall
                    color: theme.invertedColor
                }

                ComboBox {
                    id: dialog_namegender
                    anchors.right: parent.right

                    model: ListModel {
                        ListElement { text: "he/him" }
                        ListElement { text: "she/her" }
                        ListElement { text: "they/them" }
                    }
                }
            }

            Label{
                visible: false // Too long & not necessary
                id: dialog_info
                width: dialog_title.width
                wrapMode: Text.WordWrap
                font.pointSize: theme.fontSizeSmall
                color: theme.invertedColor
                anchors.horizontalCenter: parent.horizontalCenter
                text: 'This selection will be used to choose fitting pronouns for event messages. It does not affect your moose in any way.'
            }

            Rectangle{
                anchors.horizontalCenter: parent.horizontalCenter
                width: dialog_info.width
                height: dialog_button.height + theme.paddingMedium
                color: 'transparent'

                Label{
                    id: dialog_button
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: 'Rename'
                    font.underline: true
                    font.pointSize: theme.fontSizeMedium
                    color: theme.invertedColor

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            // Update animal name & namegender
                            page.namegender = dialog_namegender.currentIndex;
                            DB.setnamegender(page.id, page.namegender); // Set name gender
                            if(dialog_newname.text !== ''){
                                page.name = dialog_newname.text;
                                DB.addset(page.dna, page.name, page.age, page.id); // Rename in animals table
                                DB.ancestors_rename(page.id, page.name); // Rename in ancestors table
                            }
                            dialog.visible = false;
                        }
                    }
                }

                Label{
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: 'Cancel'
                    font.underline: true
                    color: theme.invertedColor
                    font.pointSize: theme.fontSizeMedium
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            dialog.visible = false;
                        }
                    }
                }
            }
        }
    }

    ToolBar {
        id: header
        z: 3

        RowLayout {
            anchors.fill: parent
            anchors.margins: spacing



            Text {
                text: '< About '+page.name
                font.pointSize: theme.fontSizeLarge
                z: 4
                MouseArea{
                    anchors.fill: parent
                    onClicked: pageStack.pop()
                }
            }

            Item { Layout.fillWidth: true }

            Button{
                text: 'Send home'
                visible: !page.local
                z: 5
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: theme.paddingSmall
                onClicked: {
                    pageclose.start()
                    DB.delnonlocal(page.id)// Remove guest moose
                }
            }

            Button{
                id: renamebtn
                z: 5
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: theme.paddingSmall
                text: 'Rename'
                visible: page.local && !page.ancestor
                onClicked: dialog.visible = true
            }

            Button{
                id: uploadbtn
                z: 5
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: theme.paddingSmall
                text: 'Upload'
                visible: page.local && !page.ancestor
                onClicked: upload()
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
        y: header.height
        width: parent.width
        contentHeight: col.height + 10
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
                text: "Image"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Image {
                id: image
                smooth: false
                source: 'qrc:///img/moose2.png'
                width: sourceSize.width * 2 * getscale()
                height: sourceSize.height * 2 * getscale()
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: page.name
                font.pointSize: theme.fontSizeSmall
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: "Species"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                id: speclabel
                text: ''
                font.pointSize: theme.fontSizeSmall
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label{
                text: "Age"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                id: agetext
                font.pointSize: theme.fontSizeSmall
                text: Math.floor(page.age/400)
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: "Personality"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text: pers1()
                font.pointSize: theme.fontSizeSmall
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: pers2()
                font.pointSize: theme.fontSizeSmall
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                visible: true
                text: pers3()
                font.pointSize: theme.fontSizeSmall
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: "Parents"
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Row {
                width: parent.width

                Column{
                    width: parent.width / 2

                    Image {
                        id: parentimagea
                        source: 'qrc:///img/moose_sw.png'
                        width: sourceSize.width
                        height: sourceSize.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                if(parentnamea.dna !== '0'){
                                    pageStack.push(Qt.resolvedUrl("qrc:///pages/aboutanimal.qml"), {name: parentnamea.text, dna: parentnamea.dna, age: 0, local: true, ancestor: true, id: parentnamea.id});
                                }
                            }
                        }
                    }
                    Label{
                        id: parentnamea
                        font.pointSize: theme.fontSizeSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: 'ParentA'
                        property string dna
                        property int id
                    }
                }

                Column{
                    width: parent.width / 2

                    Image {
                        id: parentimageb
                        source: 'qrc:///img/moose_sw.png'
                        width: sourceSize.width
                        height: sourceSize.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                if(parentnameb.dna !== '0'){
                                    pageStack.push(Qt.resolvedUrl("qrc:///pages/aboutanimal.qml"), {name: parentnameb.text, dna: parentnameb.dna, age: 0, local: true, ancestor: true, id: parentnameb.id});
                                }
                            }
                        }
                    }
                    Label{
                        id: parentnameb
                        font.pointSize: theme.fontSizeSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: 'ParentB'
                        property string dna
                        property int id
                    }
                }
            }

            Label {
                text: "Debug"
                visible: page.debug
                font.pointSize: theme.fontSizeMedium
                color: theme.highlightColor
                anchors{
                    left: parent.left
                    leftMargin: theme.paddingSmall
                }
            }

            Label {
                text: 'ID: '+page.id
                visible: page.debug
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
                text: 'DNA: '+ parseInt(dna, 2).toString(16); // Base16 representation of DNA
                visible: page.debug
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

    Rectangle {
        id: message
        visible: false
        anchors.centerIn: parent
        width: page.width
        height: msgtext.height * 1.3
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

    Timer{
        id: pageclose
        interval: 500
        running: false
        repeat: false
        onTriggered: {
            pageStack.pop()
        }
    }

}
