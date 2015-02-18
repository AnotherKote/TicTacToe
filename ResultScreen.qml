import QtQuick 2.0

Rectangle
{
   width: main.width
   height: main.height
   color: main.color
   visible: false
   enabled: false
   opacity: 0
   property alias text: screenText.text
   property alias textColor: screenText.color
   function buttonPressed()
   {
   }

   Text
   {
      id: screenText
      opacity: 1
      x: parent.width/4
      y: parent.height/6
      width: parent.width/2
      height: parent.height/3

      font.pixelSize: parent.height/6
      font.family: pfKidsProGradeOneFont.name
      font.bold: true
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignHCenter
   }
   Rectangle
   {
      id: shadow
      x: parent.width/4 + width/10
      y: parent.height*2/3 + width/10
      width: parent.width/2
      height: parent.height/6
      radius: height/3
      color: "black"
   }
   Rectangle
   {
      x: parent.width/4
      y: parent.height*2/3
      width: parent.width/2
      height: parent.height/6
      radius: height/3
      color: "lightgreen"
      Text
      {
         id:backToListText
         anchors.centerIn: parent
         width: parent.width*3/4
         height: parent.height
         font.family: pfKidsProGradeOneFont.name
         text: "Back to list"
         verticalAlignment: Text.AlignVCenter
         horizontalAlignment: Text.AlignHCenter
         font.pixelSize: parent.height
         scale: paintedWidth > width ? (width/paintedWidth) : 1
      }
      MouseArea
      {
         anchors.fill: parent
         onClicked:
         {
            buttonPressed()
         }
         onPressed:
         {
            parent.x += width/15
            parent.y += width/15
         }
         onReleased:
         {
            parent.x -= width/15
            parent.y -= width/15
         }
      }
   }
}

