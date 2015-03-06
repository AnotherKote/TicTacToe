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

   Text
   {
      id: hostName
      anchors.centerIn: parent
      font.family: pfKidsProGradeOneFont.name
      font.pointSize: 33
      color: "darkblue"
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignHCenter
   }

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

      MouseArea
      {
         anchors.fill: parent
         onClicked:
         {
            popupAnswer = 1
         }
      }
   }

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

      MouseArea
      {
         anchors.fill: parent
         onClicked:
         {
            popupAnswer = 2
         }
      }
   }


}

