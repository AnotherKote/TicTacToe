import QtQuick 2.0

Timer
{
//   id: drawingTimer
   running: false
   repeat: true
   interval: 5
   property variant canv: null
   property variant srcPoint: [0, 0]
   property variant dstPoint: [0, 0]
   property variant step: [0, 0]
   onTriggered:
   {
      canv.destPoint = srcPoint
//      if(srcPoint[0] < dstPoint[0])
//      {
      srcPoint[0] += step[0]
//      }
//      if(srcPoint[1] < dstPoint[1])
//      {
      srcPoint[1] += step[1]
//      }
      if(srcPoint[0] >= dstPoint[0] && srcPoint[1] >= dstPoint[1])
      {
         stop()
      }

      canv.requestPaint()
      console.log("point " + srcPoint)
   }
   onSrcPointChanged:
   {
      canv.prevPoint[0] = srcPoint[0]
      canv.prevPoint[1] = srcPoint[1]
      canv.destPoint[0] = srcPoint[0]
      canv.destPoint[1] = srcPoint[1]
      console.log( "source point changed " + srcPoint)
   }
}
