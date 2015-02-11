import QtQuick 2.0

Item
{
   property alias text: hostName.text
   visible: false
   opacity: 0
   Rectangle
   {
      width: 400
      height: 200
      x: main.width/2 - width/2
      y: main.height/2 - height/2
      radius: width*2
      color: "red"
      Text
      {
         anchors.horizontalCenter: hostName.horizontalCenter
         y: parent.y - 100
         text: "Connecting to"
         font.pointSize: 25
      }
      Text
      {
         id: hostName
         width: parent.width
         height: parent.height
         font.pointSize: 25
         verticalAlignment: Text.AlignVCenter
         horizontalAlignment: Text.AlignHCenter
      }
   }

}

