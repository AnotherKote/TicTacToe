import QtQuick 2.0

Item
{
   visible: true
   enabled: false
   opacity: 1
   property alias text: screenText.text
   property alias textColor: screenText.color
   property alias background: background

   function buttonPressed()
   {
   }

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
      id: screenText
      opacity: 0.8
      x: parent.width/4
      y: parent.height/6
      width: parent.width/2
      height: parent.height/3

      color: "darkblue"
      font.pixelSize: parent.height/8
      font.family: pfKidsProGradeOneFont.name
      font.bold: true
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignHCenter
   }

   Text
   {
      id:backToListText
      opacity: 0.8
      anchors.bottom: parent.bottom
      anchors.bottomMargin: parent.height/10
      anchors.horizontalCenter: screenText.horizontalCenter
      color: "darkblue"
      font.family: pfKidsProGradeOneFont.name
      font.bold: true
      text: "Назад к списку <br> игроков"
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignHCenter
      font.pixelSize: 33
      //      scale: paintedWidth > width ? (width/paintedWidth) : 1
      MouseArea
      {
         anchors.fill: parent
         onClicked:
         {
            console.log("buttonPressed!")
            buttonPressed()
         }
      }
   }

   Image
   {
      id: arrow
      opacity: 0.8
      smooth: true
      antialiasing: true
      fillMode: Image.PreserveAspectFit
      anchors.right: backToListText.left
      anchors.verticalCenter: backToListText.verticalCenter
      width: backToListText.x
//      horizontalAlignment: Image.AlignLeft
//      verticalAlignment: Image.AlignTop
      source: "./arrow.png"
      MouseArea
      {
         anchors.fill: parent
         onClicked:
         {
            console.log("buttonPressed!")
            buttonPressed()
         }
      }
   }
}

