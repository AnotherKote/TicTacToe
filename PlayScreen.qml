import QtQuick 2.0

Rectangle
{
   width: main.width
   height: main.height
   opacity: 1

   enabled: false
   visible: false
   id: fieldRect
   property bool isStartsFirst: true
   property int inMove
   property int outMove
   color: main.color
   Rectangle {x: parent.width/3;   y:0;                 width: 2;            height: parent.height; color: "black"}
   Rectangle {x: parent.width*2/3; y:0;                 width: 2;            height: parent.height; color: "black"}
   Rectangle {x: 0;                y:parent.height/3;   width: parent.width; height: 2;             color: "black"}
   Rectangle {x: 0;                y:parent.height*2/3; width: parent.width; height: 2;             color: "black"}

   onVisibleChanged:
   {
      if (visible == true)
      {
         field.init()
         fieldView.enabled = isStartsFirst
      }else
      {
         fieldView.enabled = false
      }
   }

   onInMoveChanged:
   {
      console.assert(inMove >= 1, "index for field is out of range")
      console.assert(inMove <= 9, "index for field is out of range")
      field.get(inMove - 1).value = (isStartsFirst)? "O" : "X"
      fieldView.enabled = true
   }

   onOutMoveChanged:
   {
      console.assert(outMove >= 1, "index for field is out of range")
      console.assert(outMove <= 9, "index for field is out of range")
      field.get(outMove).value = (isStartsFirst)? "X" : "O"
      fieldView.enabled = false
   }
//   function makeMove (index)
//   {
//      console.assert(index >= 1, "index for field is out of range")
//      console.assert(index <= 9, "index for field is out of range")
//      if (index >= 1 && index <=9)
//      {
//         field.get(index - 1).value = (isStartsFirst)? "O" : "X"
//         fieldView.enabled = true
//      }
//   }

   GridView
   {
      id: fieldView
      anchors.fill: parent
      enabled: false
      flow: GridView.FlowLeftToRight
      layoutDirection: Qt.LeftToRight
      verticalLayoutDirection: GridView.TopToBottom
      cellHeight: parent.height/3
      cellWidth: parent.width/3
      interactive: true
      ///<@todo [1]ChangeToFalse after PlayScreen testing
      focus: true
      //[1]
//      highlight: Text
//      {
//         id: highlight
//         visible: fieldView.enabled
//         width: parent.cellWidth
//         height: parent.cellHeight
//         text: (isStartsFirst)? "X" : "O"
////         font.pixelSize: width/*(width < height)? width : height*/
//         font.family: "Small Fonts"
//         verticalAlignment: Text.AlignVCenter
//         horizontalAlignment: Text.AlignHCenter
//      }
      model: ListModel
      {
         id: field
//         ListElement { value: " " }
//         ListElement { value: " " }
//         ListElement { value: " " }

//         ListElement { value: " " }
//         ListElement { value: " " }
//         ListElement { value: " " }

//         ListElement { value: " " }
//         ListElement { value: " " }
//         ListElement { value: " " }
         function init ()
         {
            for (var i = 0; i < 9; i++)
            {
               append({value: " "})
            }
         }
      }
      delegate: Item
      {
         width: main.width/3
         height: main.height/3
         Text
         {
            anchors.fill: parent
            width: parent.width
            height: parent.height
            text: value
            font.pixelSize: (parent.width < parent.height)? parent.width : parent.height
            font.family: "Small Fonts"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
         }
         MouseArea
         {
            anchors.fill: parent
            onClicked:
            {
               fieldRect.outMove = index
//               field.get(index).value = (fieldRect.isStartsFirst)? "X" : "O"
//               fieldRect.enabled = false
            }
         }
      }
      Keys.onReturnPressed:
      {
         fieldRect.outMove = currentIndex
//         field.get(currentIndex).value = (parent.isStartsFirst)? "X" : "O"
//         parent.enabled = false
      }
   }
}
