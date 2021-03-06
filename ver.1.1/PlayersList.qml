import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

ApplicationWindow {
   title: qsTr("Tic Tac Toe")
   width: 480
   height: 640

   minimumWidth: width
   maximumWidth: width
   minimumHeight: height
   maximumHeight: height

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
      id: backgroundImage
      x: 0
      y: 0
      width: Screen.desktopAvailableWidth
      height: Screen.desktopAvailableHeight

      fillMode: Image.Tile
      smooth: true
      clip: true
      horizontalAlignment: Image.AlignLeft
      verticalAlignment: Image.AlignTop
      source: background.source

      onYChanged:
      {
         console.log(" Y changed " + y)
      }
   }

   Item {
      id: screens
      state: "playersListScreen"

//      state: "requestToPlayGamePopup"
//      state: "resultScreen"
//      state: "playGameScreen"
//      state: "waitingScreen"
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
               y:0
               x:0
            }
            PropertyChanges
            {
               target: waitPopup
               visible: true
               y: main.height
            }
            PropertyChanges
            {
               target: waitingScreen
               visible: true
               text.visible: true
               y: -main.height
            }
            PropertyChanges
            {
               target: backgroundImage
               y: 0
            }
            PropertyChanges
            {
               target: playScreen
               x: main.width
               y: 0
            }
            PropertyChanges
            {
               target: resultScreen
               x: main.width
            }
         },
         State
         {
            name: "waitingScreen"
            PropertyChanges
            {
               target: viewOnlinePlayers
               visible: true
               y: waitingScreen.height
            }
            PropertyChanges
            {
               target: waitingScreen
               visible: true
               y: 0
            }
            PropertyChanges
            {
               target: backgroundImage
               y: waitingScreen.height
            }
         },
         State
         {
            name: "playGameScreen"
            PropertyChanges
            {
               target: waitPopup
               x: -main.width
            }
            PropertyChanges {
               target: waitingScreen
               x: -main.width
            }
            PropertyChanges
            {
               target: playScreen
               enabled: true
               x:0
            }
            PropertyChanges
            {
               target: backgroundImage
               x: -main.width
            }
         },
         State
         {
            name: "resultScreen"
            PropertyChanges
            {
               target: playScreen
               y: -main.height
            }
            PropertyChanges {
               target: resultScreen
               y: 0
            }
            PropertyChanges
            {
               target: backgroundImage
               y: -main.height
            }
            PropertyChanges {
               target: viewOnlinePlayers
               y: 0
               x: -main.width
            }
         },
         State
         {
            name: "requestToPlayGamePopup"
            PropertyChanges
            {
               target: viewOnlinePlayers
               visible: true
               y: -waitPopup.height
            }
            PropertyChanges
            {
               target: backgroundImage
               visible: true
               y: -waitPopup.height
            }
            PropertyChanges
            {
               target: waitPopup
               visible: true
               ynPopup: true
               y: 0
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
               properties: "y"
               duration: 2000
            }
            PropertyAnimation
            {
               target: waitingScreen;
               properties: "y"
               duration: 2000
            }
            PropertyAnimation
            {
               target: backgroundImage;
               properties: "y"
               duration: 2000
            }
         },
         Transition
         {
            from: "waitingScreen"
            to: "playersListScreen"
            PropertyAnimation
            {
               target: viewOnlinePlayers;
               properties: "y"
               duration: 2000
            }
            PropertyAnimation
            {
               target: waitingScreen;
               properties: "y"
               duration: 2000
            }
            PropertyAnimation
            {
               target: backgroundImage;
               properties: "y"
               duration: 2000
            }
         },
         Transition
         {
            from: "playersListScreen,requestToPlayGamePopup"
            to: "requestToPlayGamePopup,playersListScreen"
            PropertyAnimation
            {
               target: viewOnlinePlayers;
               properties: "y"
               duration: 2000
            }
            PropertyAnimation
            {
               target: waitPopup;
               properties: "y"
               duration: 2000
            }
            PropertyAnimation
            {
               target: backgroundImage;
               properties: "y"
               duration: 2000
            }
         },
         Transition
         {
            from: "requestToPlayGamePopup,waitingScreen"
            to: "playGameScreen"
            PropertyAnimation
            {
               targets: [waitPopup, backgroundImage, waitingScreen, playScreen]
               properties: "x"
               duration: 2000
            }
         },
         Transition
         {
            from: "playGameScreen"
            to: "resultScreen"
            PropertyAnimation
            {
               targets: [playScreen, resultScreen, backgroundImage]
               properties: "y"
               duration: 2000
            }
         },
         Transition
         {
            from: "resultScreen"
            to: "playersListScreen"
            PropertyAnimation
            {
               targets: [viewOnlinePlayers, resultScreen, backgroundImage]
               properties: "x"
               duration: 2000
            }
         }
      ]
   }

   WaitingScreen
   {
      id: waitingScreen

      x:0
      y: -parent.height
      width: parent.width
      height: parent.height

      background.width: Screen.desktopAvailableWidth
      background.height: Screen.desktopAvailableHeight
      text.font.family: pfKidsProGradeOneFont.name

      onYChanged:
      {
         if(y === 0)
         {
            animation.start()
         }else
         {
            animation.stop()
         }
      }
   }


   WaitPopup{
      objectName: "waitPopup"
      id: waitPopup
      text: "Начать игру с <br>127.0.0.1"

      x:0
      y: parent.height
      width: parent.width
      height: parent.height

      background.width: Screen.desktopAvailableWidth
      background.height: Screen.desktopAvailableHeight

      onPopupAnswerChanged:
      {
         onlineListController.popupAnswer = popupAnswer
         console.log("popup answer" + popupAnswer)
         popupAnswer = 0
      }
   }

   PlayScreen{
      id: playScreen
      x: main.width
      width: parent.width
      height: parent.height
      background.width: Screen.desktopAvailableWidth
      background.height: Screen.desktopAvailableHeight
   }

   ResultScreen{
      id: resultScreen

      x:0
      y: parent.height
      width: parent.width
      height: parent.height

      background.width: Screen.desktopAvailableWidth
      background.height: Screen.desktopAvailableHeight

      text: "Победа!"

      function buttonPressed()
      {
         console.log("button pressed!!")
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

   PropertyAnimation{

   }

   ListView {
      id: viewOnlinePlayers
//      anchors.fill: parent
      x: 0
      y: 0
      height: parent.height
      width: parent.width
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
//            text.text: "Ожидаем ответа от <br> " + onlinePlayers.get(viewOnlinePlayers.currentIndex).myCoolText + "<br>"
            waitingScreen.text.text = "Ожидаем ответа от <br> " + onlinePlayers.get(viewOnlinePlayers.currentIndex).myCoolText + "<br>"
//            waitingScreen.visible = true
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
            x: 0
            y: 0
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
