import QtQuick 2.0

Rectangle
{
   width: main.width
   height: main.height
   opacity: 1
   id: root

   enabled: false
   visible: false
   property bool isStartsFirst: true
   property int inMove : 9
   property int outMove : 9
   color: main.color

   Canvas
   {
       id: canvas
       anchors.fill: parent
       property variant destPoint: [0, 0]
       property variant prevPoint: [0, 0]
       onPaint:
       {
          var ctx = getContext('2d')
          ctx.strokeStyle = "darkblue"
          ctx.lineWidth = 3
          ctx.lineCap = 'round'

          ctx.beginPath()
          ctx.moveTo(prevPoint[0], prevPoint[1])
          ctx.lineTo(destPoint[0], destPoint[1])
          prevPoint[0] = destPoint[0]
          prevPoint[1] = destPoint[1]
          ctx.stroke()
//          ctx.closePath()
          console.log("prevPoint " + prevPoint + " destPoint " + destPoint)
       }
   }

   function drawField()
   {
      drawingTimerHorizontal1.srcPoint = [root.width/3, Math.random() * height/8]
      drawingTimerHorizontal1.dstPoint = [root.width/3, root.height - Math.random() * height/8]
      drawingTimerHorizontal1.step = [0, 20]
      drawingTimerHorizontal1.start()
   }

   DrawingTimer
   {
      id: drawingTimerHorizontal1
      canv: canvas
      onRunningChanged:
      {
         if (running == false)
         {
            drawingTimerHorizontal2.srcPoint = [root.width*2/3, Math.random() * height/8]
            drawingTimerHorizontal2.dstPoint = [root.width*2/3, root.height - Math.random() * height/8]
            drawingTimerHorizontal2.step = [0, 20]
            drawingTimerHorizontal2.start()
         }
      }
   }

   DrawingTimer
   {
      id: drawingTimerHorizontal2
      canv: canvas
      onRunningChanged:
      {
         if (running == false)
         {
            drawingTimerVertical1.srcPoint = [Math.random() * width/8, root.height/3]
            drawingTimerVertical1.dstPoint = [width - Math.random() * width/8, root.height/3]
            drawingTimerVertical1.step = [20, 0]
            drawingTimerVertical1.start()
         }
      }
   }

   DrawingTimer
   {
      id: drawingTimerVertical1
      canv: canvas
      onRunningChanged:
      {
         if (running == false)
         {
            drawingTimerVertical2.srcPoint = [Math.random() * width/8, root.height*2/3]
            drawingTimerVertical2.dstPoint = [width - Math.random() * width/8, root.height*2/3]
            drawingTimerVertical2.step = [20, 0]
            drawingTimerVertical2.start()
         }
      }
   }

   DrawingTimer
   {
      id: drawingTimerVertical2
      canv: canvas
      onRunningChanged:
      {
         if (running == false)
         {
            drawCross(0)
         }
      }
   }

   onWidthChanged:
   {
      drawField()
   }

   onHeightChanged:
   {
      drawField()
   }

   onVisibleChanged:
   {
      if (visible == true)
      {
         field.init()
         fieldView.enabled = isStartsFirst
         drawField()
      }else
      {
         fieldView.enabled = false
      }
   }

   function drawNought(index)
   {

   }

   function drawCross(index)
   {
      var topLeftCornerX = (root.width * index%3)/3
      var topLeftCornerY = (root.height * index/3)/3

      drawingCross1.srcPoint = [topLeftCornerX, topLeftCornerY]
      drawingCross1.dstPoint = [topLeftCornerX + root.width/3, topLeftCornerY + root.height/3]
      drawingCross1.step = [20, 20]

      drawingCross1.start()
   }

   DrawingTimer
   {
      id: drawingCross1
      canv: canvas
      onRunningChanged:
      {
         if (running == false)
         {
            drawingCross2.srcPoint = [dstPoint[0], srcPoint[1]]
            drawingCross2.dstPoint = [srcPoint[0], dstPoint[1]]
            drawingCross2.step = [0, 20]
            drawingCross2.start()
            console.log("second cross")
         }
      }
   }

   DrawingTimer
   {
      id: drawingCross2
      canv: canvas
   }

   onInMoveChanged:
   {
      console.assert(inMove >= 0, "index for field is out of range")
      console.assert(inMove <= 8, "index for field is out of range")
      field.get(inMove).value = (isStartsFirst)? fieldValues.zero : fieldValues.cross
      fieldView.enabled = true
      checkCollision()
   }

   onOutMoveChanged:
   {
      console.assert(outMove >= 0, "index for field is out of range")
      console.assert(outMove <= 8, "index for field is out of range")
      console.log("OutMove " + outMove)
      field.get(outMove).value = (isStartsFirst)? fieldValues.cross : fieldValues.zero
      fieldView.enabled = false
      onlineListController.makeMove(outMove)
      checkCollision()
   }

   Item
   {
      id: winningResult
      readonly property int contPlaying: 0
      readonly property int youWon:      1
      readonly property int youLose:     2
      readonly property int draw:        3
   }

   Item
   {
      id: fieldValues
      property string cross: "X"
      property string zero:  "O"
      property string empty: " "
      property string crossLine: cross + cross + cross
      property string zeroLine: zero + zero + zero
   }

   function isWinnigCombination(combination)
   {
      var ret = winningResult.contPlaying
      if(combination === fieldValues.crossLine)
      {
         if(isStartsFirst)
         {
            ret = winningResult.youWon
         } else
         {
            ret = winningResult.youLose
         }
      } else if (combination === fieldValues.zeroLine)
      {
         if(!isStartsFirst)
         {
            ret = winningResult.youWon
         } else
         {
            ret = winningResult.youLose
         }
      }
      return ret
   }

   function checkCollision()
   {
      var size = 3

      var ret = winningResult.contPlaying

      var temp = "";
      for(var i = 0; i < size; ++i) //checking row and columns
      {
         temp = "";
         for (var j = i * size; j < size *(i+1); j++)
         {
            temp += field.get(j).value
         }
         if(isWinnigCombination(temp) === winningResult.contPlaying)
         {
            temp = "";
            for (j = i; j <= size *2 + i; j += size)
            {
               temp += field.get(j).value
            }
         } else
         {
            break;
         }
         if (isWinnigCombination(temp) !== winningResult.contPlaying)
         {
            break;
         }
      }
      if (isWinnigCombination(temp) === winningResult.contPlaying)
      {
//         temp = "";
         temp = field.get(0).value + field.get(4).value + field.get(8).value
      }
      if (isWinnigCombination(temp) === winningResult.contPlaying)
      {
         temp = field.get(2).value + field.get(4).value + field.get(6).value
      }
      ret = isWinnigCombination(temp)
      if (ret === winningResult.contPlaying)
      {
         ret = winningResult.draw
         for (i = 0; i < size*size; ++i)
         {
//            console.log("field.get(i) <" + field.get(i) + ">")
            if(field.get(i).value === fieldValues.empty)
            {
               ret = winningResult.contPlaying
               break;
            }
         }
      }

      switch (ret)
      {
      case winningResult.contPlaying:
      break;
      case winningResult.youWon:
         resultScreen.text = "You <br> Won!!!"
         resultScreen.textColor = "green"
         main.state = "resultScreen"
      break;
      case winningResult.youLose:
         resultScreen.text = "You <br> Lose =("
         resultScreen.textColor = "red"
         main.state = "resultScreen"
      break;
      case winningResult.draw:
         resultScreen.text = "Draw"
         resultScreen.textColor = "blue"
         main.state = "resultScreen"
      break;
      default:
      break;
      }
   }

   GridView
   {
      id: fieldView
      anchors.fill: parent
      enabled: true
      flow: GridView.FlowLeftToRight
      layoutDirection: Qt.LeftToRight
      verticalLayoutDirection: GridView.TopToBottom
      cellHeight: parent.height/3
      cellWidth: parent.width/3
      interactive: false
      ///<@todo [1]ChangeToFalse after PlayScreen testing
      focus: true
      //[1]
//      highlight: Text
//      {
//         id: highlightWin
//         visible: false
//         width: fieldView.cellWidth
//         height: fieldView.cellHeight
//         text: (isStartsFirst)? "X" : "O"
//         font.pixelSize: height/*(width < height)? width : height*/
//         font.family: pfKidsProGradeOneFont.name
//         verticalAlignment: Text.AlignVCenter
//         horizontalAlignment: Text.AlignHCenter
//      }
      model: ListModel
      {
         id: field
         function init ()
         {
            field.clear()
            for (var i = 0; i < 9; i++)
            {
               append({value: fieldValues.empty})
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
            font.family: pfKidsProGradeOneFont.name
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
         }
         MouseArea
         {
            anchors.fill: parent
            onClicked:
            {
               console.log("on Mouse click " + index + " field value: " + field.get(index).value)
               if(field.get(index).value === fieldValues.empty)
               {
                  root.outMove = index
               }
            }
         }
      }
      Keys.onReturnPressed:
      {
         root.outMove = currentIndex
      }
      onEnabledChanged:
      {
         if(enabled == false)
         {
            fadeOutWhenDisable.start()
         }
         else
         {
            appearWhenEnable.start()
         }
      }
      PropertyAnimation
      {
         id: fadeOutWhenDisable
         target: root
         easing.type: Easing.OutExpo
         properties: "opacity"
         to: 0.3
         duration: 1500
      }
      PropertyAnimation
      {
         id: appearWhenEnable
         target: root
         easing.type: Easing.InExpo
         properties: "opacity"
         to: 1
         duration: 1000
      }
   }
}
