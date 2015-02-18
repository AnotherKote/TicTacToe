import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

ApplicationWindow {
   title: qsTr("Tic Tac Toe")
   width: 480
   height: 640

   visible: true
   color: "white"
   id: main
   objectName: "mainWindow"
   property alias isStartsFirst: playScreen.isStartsFirst
   property alias inMove: playScreen.inMove
   property alias outMove: playScreen.outMove
   property alias state: screens.state

   FontLoader { id: pfKidsProGradeOneFont; source: "./PFKidsProGradeOne.ttf" }

   Image
   {
      id: background
      source: "./backgroudFill.png"
   }

   Image
   {
      width: Screen.desktopAvailableWidth
      height: Screen.desktopAvailableHeight

      fillMode: Image.Tile
      smooth: true
      clip: true
      horizontalAlignment: Image.AlignLeft
      verticalAlignment: Image.AlignTop
      source: background.source
   }

   Item {
      id: screens
//      state: "playersListScreen"

//      state: "resultScreen"
//      state: "playGameScreen"
      state: "waitingScreen"
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
            name: "waitingScreen"
            PropertyChanges
            {
               target: viewOnlinePlayers
               focus: false
               enabled: false
            }
            PropertyChanges
            {
               target: waitingScreen
               text.text: "Ожидаем ответа от <br> " + onlinePlayers.get(viewOnlinePlayers.currentIndex).myCoolText + "<br>"
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
            to: "waitingScreen"
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

   WaitingScreen
   {
      id: waitingScreen
      anchors.fill: parent

      background.width: Screen.desktopAvailableWidth
      background.height: Screen.desktopAvailableHeight
      text.font.family: pfKidsProGradeOneFont.name

      onVisibleChanged:
      {
         waitingTimer.start()
      }
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
         height: background.height * 2
         anchors.horizontalCenter: main.horizontalCenter
         id: delegateRoot
         Row {
            Item
            {
               anchors.verticalCenter: parent.verticalCenter
               Image
               {
                  smooth: true
                  clip: true
                  source: "./backgroudFill.png"
                  fillMode: Image.Tile
                  width: main.width
                  height: delegateRoot.height
                  horizontalAlignment: Image.AlignLeft
                  verticalAlignment: Image.AlignTop
                  z: 100
               }
               Text {
                  z: 150
                  y: delegateRoot.height - paintedHeight + background.height/3
                  width: main.width
                  height: delegateRoot.height
                  color: "darkblue"
                  opacity: 0.9
                  anchors.horizontalCenter: main.horizontalCenter
                  text: myCoolText
                  font.family: pfKidsProGradeOneFont.name
                  horizontalAlignment: Text.AlignHCenter
//                  verticalAlignment: Text.AlignBottom
                  font.pointSize: 30
               }
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
      clip: true
      boundsBehavior: Flickable.StopAtBounds
      Keys.onReturnPressed:
      {
         if(onlinePlayers.count != 0)
         {
            screens.state = "waitingScreen"
            onlineListController.requestToStartGame(onlinePlayers.get(currentIndex).myCoolText)
         }
      }
      header: Item {
         z: 200
         id: viewHeader
         width: parent.width
         height: background.height * 2
         Image
         {
            smooth: true
            clip: true
            source: "./backgroudFill.png"
            fillMode: Image.Tile
            width: parent.width
            height: parent.height
            horizontalAlignment: Image.AlignLeft
            verticalAlignment: Image.AlignTop
         }
         Text{
            y: parent.height - paintedHeight + background.height/3
            anchors.horizontalCenter: parent.horizontalCenter
            color: "red";
            font.family: pfKidsProGradeOneFont.name
            text: "Список игроков:";
            opacity: 0.8
            height: parent.height
            font.pointSize: 32
         }
      }
      highlight: Item
      {
         z: 120
         id: highlightAnimation
         AnimatedImage {
            id: anim
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height
            z: 120
            scale:0.8
            opacity: 0.8
            source: "./animation/Underline.gif"
         }
         onYChanged:
         {
            anim.currentFrame = 0
            anim.playing = true
         }
      }

      model: onlinePlayers
      delegate: delegate
   }
}
