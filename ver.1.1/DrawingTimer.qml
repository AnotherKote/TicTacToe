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
   property int delta: 0
   onTriggered:
   {
      canv.destPoint = srcPoint
      canv.requestPaint()

      function sign(x) {
          return typeof x === 'number' ? x ? x < 0 ? -1 : 1 : x === x ? 0 : NaN : NaN;
      }

      srcPoint[0] += step[0]
      srcPoint[1] += step[1]

      var mustStop = false

      if(sign(step[0]) !== -1)
      {
         if(srcPoint[0] >= dstPoint[0])
         {
            mustStop = true
         }
      } else
      {
         if(srcPoint[0] <= dstPoint[0])
         {
            mustStop = true
         }
      }

      if(sign(step[1]) !== -1)
      {
         if(mustStop && srcPoint[1] >= dstPoint[1])
         {
            stop()
         }
      } else
      {
         if(mustStop && srcPoint[1] <= dstPoint[1])
         {
            stop()
         }
      }

//      if(srcPoint[0] >= dstPoint[0] && srcPoint[1] >= dstPoint[1])
//      {
//         stop()
//      }

      console.log("point " + srcPoint + "dest point " + dstPoint + " mustStop " + mustStop + " sign step[0] " + sign(step[0]) + " sign step[1] " + sign(step[1]))
   }
   onRunningChanged:
   {
      if(running == true)
      {
         canv.prevPoint[0] = srcPoint[0]
         canv.prevPoint[1] = srcPoint[1]
         canv.destPoint[0] = srcPoint[0]
         canv.destPoint[1] = srcPoint[1]
         console.log( "source point changed " + srcPoint)
      }
   }
}
