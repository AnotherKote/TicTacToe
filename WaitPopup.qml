import QtQuick 2.0

Item
{
   property alias text: hostName.text

   property bool ynPopup: false
   property bool isYesPressed: false
   property bool isNoPressed: !isYesPressed

   visible: false
   opacity: 0

   Rectangle
   {
      width: 400
      height: 200
      x: main.width/2 - width/2
      y: main.height/2 - height/2
      radius: width*2
      color: "darkgrey"
//      Text
//      {
//         anchors.horizontalCenter: parent.horizontalCenter
//         y: parent.y/3
//         font.family: "Small Fonts"
////         text: ""
//         font.pointSize: 25
//      }
      Text
      {
         id: hostName
         anchors.fill: parent
         font.family: "Small Fonts"
         font.pointSize: 25
         verticalAlignment: Text.AlignVCenter
         horizontalAlignment: Text.AlignHCenter
      }
      Rectangle
      {
         id: yes
         visible: ynPopup
         x: parent.width/5
         y: parent.height*4/6
         width: parent.width*3/10
         height: parent.height/6
         color: "lightgreen"

         Text
         {
            anchors.fill: parent
            text: "Yes"
            font.family: "Small Fonts"
            font.pixelSize: height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
         }

         MouseArea
         {
            anchors.fill: parent
            onClicked:
            {
               isYesPressed = true
            }
         }
      }
      Rectangle
      {
         id: no
         visible: ynPopup
         x: yes.x + yes.width
         y: yes.y
         width: yes.width
         height: yes.height
         color: "red"
         Text
         {
            anchors.fill: parent
            text: "No"
            font.family: "Small Fonts"
            font.pixelSize: height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
         }

         MouseArea
         {
            anchors.fill: parent
            onClicked:
            {
               isYesPressed = false
            }
         }
      }
   }
}

