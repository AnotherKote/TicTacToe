import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
//import MyCoolTTT 1.0

ApplicationWindow {
    title: qsTr("Hello World")
    width: 640
    height: 480

    visible: true
    color: "grey"
    id: main
    objectName: "mainWindow"

    Component {
        id: delegate
        Item {
            width: main.width
            height: 70
            anchors.horizontalCenter: main.horizontalCenter
            Row {
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    width: main.width
                    anchors.horizontalCenter: main.horizontalCenter
                    text: myCoolText
                    font.family: "Small Fonts"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 29
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: viewOnlinePlayers.currentIndex = index
            }
        }
    }

    ListModel {
        id: onlinePlayers
        objectName: "onlinePlayersList"
        dynamicRoles: true

        function addToList(msg)
        {
            append({ myCoolText: msg })
        }
    }

    ListView {
        id: viewOnlinePlayers
        anchors.fill: parent
        focus: true
        Keys.onReturnPressed:
        {
            onlineListController.requestToStartGame(onlinePlayers.get(currentIndex).myCoolText)
        }

        header: Rectangle {
            width: parent.width
            height: 30
            gradient: Gradient {
                GradientStop {position: 0; color: "gray"}
                GradientStop {position: 0.7; color: "black"}
            }
            Text{
                anchors.centerIn: parent;
                color: "gray";
                font.family: "Small Fonts"
                text: "online players";
                font.bold: true;
                font.pointSize: 20
            }
        }
        footer: Rectangle {
            width: main.width
            height: 30
            gradient: Gradient {
                GradientStop {position: 0; color: "gray"}
                GradientStop {position: 0.7; color: "black"}
            }
        }
        highlight: Rectangle {
            width: main.width
            color: "red"
        }
        model: onlinePlayers
        delegate: delegate
    }
}
