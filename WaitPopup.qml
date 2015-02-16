import QtQuick 2.0

Item
{
   property alias text: hostName.text

   property bool ynPopup: false
   property int popupAnswer: 0

   visible: false
   opacity: 0

   Rectangle
   {
      x: main.width/4
      y: main.height*3/8
      width: main.width/2
      height: main.height/4
      radius: height/4
      color: "darkgrey"

      Text
      {
         id: hostName
         x: 0
         y: 0
         height: parent.height*2/3
         width: parent.width
         font.family: "Small Fonts"
         font.pointSize: 25
         verticalAlignment: Text.AlignVCenter
         horizontalAlignment: Text.AlignHCenter
         scale: paintedWidth > width ? (width/paintedWidth) : paintedHeight > height ? (height/paintedHeight) : 1
      }

      Rectangle
      {
         id: yesShadow
         visible: ynPopup
         x: parent.width/8 + width/10
         y: parent.height*4/6 + width/10
         width: yes.width
         height: yes.height
         radius: yes.radius
         color: "black"
      }

      Rectangle
      {
         id: yes
         visible: ynPopup
         x: parent.width/8
         y: parent.height*4/6
         width: parent.width/4
         height: parent.height/6
         color: "lightgreen"
         radius: height/2
         Text
         {
            anchors.fill: parent
            width: parent.width
            text: "Yes"
            font.family: "Small Fonts"
            font.pixelSize: height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            scale: paintedWidth > width ? (width/paintedWidth) : 1
         }

         MouseArea
         {
            anchors.fill: parent
            onClicked:
            {
               popupAnswer = 1
            }
            onPressed:
            {
               parent.x += width/25
               parent.y += width/25
            }
            onReleased:
            {
               parent.x -= width/25
               parent.y -= width/25
            }
         }
      }

      Rectangle
      {
         id: noShadow
         visible: ynPopup
         x: parent.width*5/8 + width/10
         y: parent.height*4/6 + width/10
         width: no.width
         height: no.height
         radius: no.radius
         color: "black"
      }

      Rectangle
      {
         id: no
         visible: ynPopup
         x: parent.width*5/8
         y: parent.height*4/6
         width: yes.width
         height: yes.height
         color: "red"
         radius: yes.radius
         Text
         {
            anchors.fill: parent
            text: "No"
            font.family: "Small Fonts"
            font.pixelSize: height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            scale: paintedWidth > width ? (width/paintedWidth) : 1
         }

         MouseArea
         {
            anchors.fill: parent
            onClicked:
            {
               popupAnswer = 2
            }
            onPressed:
            {
               parent.x += width/25
               parent.y += width/25
            }
            onReleased:
            {
               parent.x -= width/25
               parent.y -= width/25
            }
         }
      }
   }
}

