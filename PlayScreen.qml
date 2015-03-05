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
//            coolCrossTimer.start()
//            circleTimer.start()
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
      var topLeftCornerX = (root.width * (index%3))/3
      var topLeftCornerY = (root.height * Math.floor(index/3))/3
      console.log("Index " + index + " Index%3 " + index%3 + " Index/3 " + Math.floor(index/3))
      var width = root.width/3
      var height = root.height/3
      var margin = 20
      topLeftCornerX += margin
      topLeftCornerY += margin
      width -= 2 * margin
      height -= 2 * margin

      circleTimer.centerPoint[0] = topLeftCornerX + width/2
      circleTimer.centerPoint[1] = topLeftCornerY + height/2
      circleTimer.radius = (width > height)? height/2 : width/2
      circleTimer.start()
   }

   Timer
   {
      id: circleTimer
      running: false
      repeat: true
      property real pointAngle: 0
      interval: 5
      property variant centerPoint: [0, 0]
      property variant startPoint: [0, 0]
      property real radius: 0
      onTriggered:
      {
         function rotate (point, angle)
         {
            var rotated_point = [0, 0];
            rotated_point[0] = point[0] * Math.cos(angle) - point[1] * Math.sin(angle) + centerPoint[0];
            rotated_point[1] = point[0] * Math.sin(angle) + point[1] * Math.cos(angle) + centerPoint[1];
            return rotated_point;
         }

         var destPoint = rotate (startPoint, pointAngle)

         canvas.destPoint[0] = destPoint [0]
         canvas.destPoint[1] = destPoint [1]
         console.log("pointAngle.toFixed(1) " + pointAngle.toFixed(1) + " (2*Math.PI).toFixed(1) " + (2*Math.PI).toFixed(1))
         canvas.requestPaint()

         if(pointAngle.toFixed(1) === (2*Math.PI).toFixed(1))
         {
            stop()
         }
         pointAngle += 0.1

      }
      onRunningChanged:
      {
         if(running == true)
         {
            pointAngle = 0
            startPoint[0] = 0
            startPoint[1] = -radius
            canvas.prevPoint[0] = startPoint[0] + centerPoint[0]
            canvas.prevPoint[1] = startPoint[1] + centerPoint[1]
            canvas.destPoint[0] = startPoint[0] + centerPoint[0]
            canvas.destPoint[1] = startPoint[1] + centerPoint[1]
         }
      }
   }

   function drawCross(index)
   {
      var topLeftCornerX = (root.width * (index%3))/3
      var topLeftCornerY = (root.height * Math.floor(index/3))/3
      console.log("Index " + index + " Index%3 " + index%3 + " Index/3 " + Math.floor(index/3))
      var width = root.width/3
      var height = root.height/3
      var margin = 20
      topLeftCornerX += margin
      topLeftCornerY += margin
      width -= 2 * margin
      height -= 2 * margin
      console.log("cross " + " width " + width + " height " + height + " X " + topLeftCornerX + " Y " + topLeftCornerY)
      if(width > height)
      {
         drawingCross1.srcPoint = [topLeftCornerX + (width - height)/2, topLeftCornerY]
         drawingCross1.dstPoint = [topLeftCornerX + width - (width - height)/2, topLeftCornerY + height]
         drawingCross2.srcPoint = [topLeftCornerX + width - (width - height)/2, topLeftCornerY]
         drawingCross2.dstPoint = [topLeftCornerX + (width - height)/2, topLeftCornerY + height]
      }else
      {
         drawingCross1.srcPoint = [topLeftCornerX, topLeftCornerY + (height - width)/2]
         drawingCross1.dstPoint = [topLeftCornerX + width, topLeftCornerY + height - (height - width)/2]
         drawingCross2.srcPoint = [topLeftCornerX + width, topLeftCornerY + (height - width)/2]
         drawingCross2.dstPoint = [topLeftCornerX, topLeftCornerY + height - (height - width)/2]
      }

      drawingCross1.step = [3, 3]
      drawingCross1.interval = 2

      drawingCross2.step = [-3, 3]
      drawingCross2.interval = 2

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
            drawingCross2.start()
         }
      }
   }

   DrawingTimer
   {
      id: drawingCross2
      canv: canvas
   }

//   Timer
//   {
//      id: coolCrossTimer
//      property int index : 0
//      running: false
//      repeat: true
//      interval: 5000
//      onTriggered:
//      {
//         if(index != 9)
//         {
//            drawCross(index++)
//         } else
//         {
//            stop()
//         }
//      }
//   }

   onInMoveChanged:
   {
      console.assert(inMove >= 0, "index for field is out of range")
      console.assert(inMove <= 8, "index for field is out of range")
//      field.get(inMove).value = (isStartsFirst)? fieldValues.nought : fieldValues.cross
      if(isStartsFirst)
      {
         drawNought(inMove)
//         drawCross(outMove)
         field.get(inMove).value = fieldValues.nought
      } else
      {
         drawCross(inMove)
         field.get(inMove).value = fieldValues.cross
      }
      fieldView.enabled = true
      checkCollision()
   }

   onOutMoveChanged:
   {
      console.assert(outMove >= 0, "index for field is out of range")
      console.assert(outMove <= 8, "index for field is out of range")
      console.log("OutMove " + outMove)
//      field.get(outMove).value = (isStartsFirst)? fieldValues.cross : fieldValues.nought
      if(isStartsFirst)
      {
         drawCross(outMove)
         field.get(outMove).value = fieldValues.cross
      } else
      {
         drawNought(outMove)
         field.get(outMove).value = fieldValues.nought
      }

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
      property string nought:  "O"
      property string empty: " "
      property string crossLine: cross + cross + cross
      property string noughtLine: nought + nought + nought
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
      } else if (combination === fieldValues.noughtLine)
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
//         Text
//         {
//            anchors.fill: parent
//            width: parent.width
//            height: parent.height
//            text: value
//            font.pixelSize: (parent.width < parent.height)? parent.width : parent.height
//            font.family: pfKidsProGradeOneFont.name
//            verticalAlignment: Text.AlignVCenter
//            horizontalAlignment: Text.AlignHCenter
//         }
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
