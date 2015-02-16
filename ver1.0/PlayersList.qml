import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

ApplicationWindow {
   title: qsTr("Tic Tac Toe")
   width: 480
   height: 640

   visible: true
   color: "grey"
   id: main
   objectName: "mainWindow"
   property alias isStartsFirst: playScreen.isStartsFirst
   property alias inMove: playScreen.inMove
   property alias outMove: playScreen.outMove
   property alias state: screens.state
   Item {
      id: screens
      state: "playersListScreen"

//      state: "resultScreen"
//      state: "playGameScreen"
//      state: "requestToPlayGamePopup"
      states: [
         State
         {
            name: "playersListScreen"
            PropertyChanges
            {
               target: viewOnlinePlayers
               focus: true
               visible: true
               enabled: true
               opacity: 1
            }
            PropertyChanges
            {
               target: waitPopup
               visible: false
            }
         },
         State
         {
            name: "requestConnectionPopup"
            PropertyChanges
            {
               target: viewOnlinePlayers
               focus: false
               enabled: false
            }
            PropertyChanges
            {
               target: waitPopup
               text: "Connecting to <br> " + onlinePlayers.get(viewOnlinePlayers.currentIndex).myCoolText
               visible: true
            }
         },
         State
         {
            name: "playGameScreen"
            PropertyChanges
            {
               target: waitPopup
               visible: false
            }
            PropertyChanges
            {
               target: playScreen
               visible: true
               enabled: true
            }
            PropertyChanges
            {
               target: viewOnlinePlayers
               focus:   false
               visible: false
               enabled: false
            }
         },
         State
         {
            name: "resultScreen"
            PropertyChanges
            {
               target: playScreen
               visible: true
//               enabled: false
            }
            PropertyChanges {
               target: resultScreen
               visible: true
               enabled: true
               opacity: 0.8
            }
         },
         State
         {
            name: "requestToPlayGamePopup"
            PropertyChanges
            {
               target: viewOnlinePlayers
               focus: false
               enabled: false
               opacity: 0.5
            }
            PropertyChanges
            {
               target: waitPopup
               visible: true
               ynPopup: true
               opacity: 1
            }
         }

      ]
      transitions:
      [
         Transition
         {
            from: "playersListScreen"
            to: "requestConnectionPopup"
            PropertyAnimation
            {
               target: viewOnlinePlayers;
               easing.period: 0.08
               easing.amplitude: 2.05
               easing.type: Easing.OutQuart
               properties: "opacity"
               to: 0
               duration: 3000
            }
            PropertyAnimation
            {
               target: waitPopup
               easing.type: Easing.InQuart
               properties: "opacity"
               to: 1
               duration: 3000
            }
         },
         Transition
         {
            from: "playGameScreen"
            to: "resultScreen"
            PropertyAnimation
            {
               target: resultScreen
               easing.type: Easing.Linear
               properties: "opacity"
               to: 0.7
               duration: 3000
            }
         }

      ]
   }

   WaitPopup{
      objectName: "waitPopup"
      id: waitPopup
      text: "identifying..."
      onPopupAnswerChanged:
      {
         onlineListController.popupAnswer = popupAnswer
         console.log("popup answer" + popupAnswer)
         popupAnswer = 0
      }
   }

   PlayScreen{
      id: playScreen
   }

   ResultScreen{
      id: resultScreen
      function buttonPressed()
      {
         onlinePlayers.clear()
         screens.state = "playersListScreen"
         onlineListController.returnToList();
      }
   }

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
      opacity: 1
      visible: false
      Keys.onReturnPressed:
      {
         if(onlinePlayers.count != 0)
         {
            screens.state = "requestConnectionPopup"
            onlineListController.requestToStartGame(onlinePlayers.get(currentIndex).myCoolText)
         }
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
