import QtQuick 2.0

Item
{
   property alias text: hostName.text
   property alias background: background
   property bool ynPopup: false
   property int popupAnswer: 0

   visible: false
   opacity: 0.8

   Image
   {
      id: background
      fillMode: Image.Tile
      smooth: true
      clip: true
      horizontalAlignment: Image.AlignLeft
      verticalAlignment: Image.AlignTop
      source: "./backgroudFill.png"
   }

//   Rectangle
//   {
//      x: main.width/4
//      y: main.height*3/8
//      width: main.width/2
//      height: main.height/4
//      radius: height/4
//      color: "transparent"
//      border.color: "darkblue"
//      border.width: 2
//      smooth: true

      Text
      {
         id: hostName
         anchors.centerIn: parent
//         x: parent.width/2 - width/2
//         y: parent.height/2 - height/2
         font.family: pfKidsProGradeOneFont.name
         font.pointSize: 33
         color: "darkblue"
         verticalAlignment: Text.AlignVCenter
         horizontalAlignment: Text.AlignHCenter
//         scale: paintedWidth > width ? (width/paintedWidth) : paintedHeight > height ? (height/paintedHeight) : 1
      }

//      Rectangle
//      {
//         id: yes
//         visible: ynPopup
//         x: parent.width/8
//         y: parent.height*4/6
//         width: parent.width/4
//         height: parent.height/6
//         color: "transparent"
//         radius: height/2
         Text
         {
            anchors.top: hostName.bottom
            x: hostName.x
            text: "Да"
            font.family: pfKidsProGradeOneFont.name
            font.pixelSize: 33
            color: "darkblue"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
//            scale: paintedWidth > width ? (width/paintedWidth) : 1

            MouseArea
            {
               anchors.fill: parent
               onClicked:
               {
                  popupAnswer = 1
               }
            }
         }

//      }


//      Rectangle
//      {
//         id: no
//         visible: ynPopup
//         x: parent.width*5/8
//         y: parent.height*4/6
//         width: yes.width
//         height: yes.height
//         color: "transparent"
//         radius: yes.radius
         Text
         {
            anchors.top: hostName.bottom
            x: hostName.x + hostName.width - width
            text: "Нет"
            font.family: pfKidsProGradeOneFont.name
            font.pixelSize: 33
            color: "darkblue"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
//            scale: paintedWidth > width ? (width/paintedWidth) : 1

            MouseArea
            {
               anchors.fill: parent
               onClicked:
               {
                  popupAnswer = 2
               }
            }
         }

//      }
//   }
}

