import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtMultimedia 5.0
import 'qrc:///pages'

ApplicationWindow{
    id: rootwindow
    visible: true
    minimumHeight: 400
    minimumWidth: 400

    onClosing: {
        if(pageStack.depth > 1){
            close.accepted = false
            pageStack.pop();
        }else{
            return;
        }
    }

    StackView {
        id: pageStack
        anchors.fill: parent
        initialItem: {"item" : Qt.resolvedUrl("qrc:///pages/first.qml"), "properties" : {"width" : rootwindow.width, "height" : rootwindow.height}}
    }
}
