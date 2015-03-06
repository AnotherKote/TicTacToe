import QtQuick 2.0
import QtQuick.Particles 2.0

Item  {
   id: root

   property alias background: background
   property alias text: text
   property alias waitingTimer: waitingTimer
   property alias animation: particleSystem

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
      id: text
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignHCenter
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      font.pointSize: 33
      color: "darkblue"
      opacity: 0.8
   }

   Text
   {
      id: waitingText
      height: text.height
      anchors.top: text.bottom
      font.pointSize: 35
      color: "darkblue"
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignHCenter
   }

   ParticleSystem {
       id: particleSystem
       running: false
   }

   Emitter {
       id: emitter
//       anchors.fill: parent
//       anchors.right: parent.right
       x: 0
       y: parent.height - height*2/3
       width: parent.width/2; height: (parent.height - (text.y + text.height))

       system: particleSystem

       emitRate: 1
       lifeSpan: 500000
       lifeSpanVariation: 5000
       size: 250
       sizeVariation: 70
       endSize: 300

       shape: MaskShape {source: "./mask.png"}
   }

   Timer
   {
      interval: 500
      repeat: true
      running: particleSystem.running
      onTriggered:
      {
         if(emitter.x >= parent.width)
         {
            emitter.x = 0
            emitter.y -= 10
         }
         emitter.x += 1
      }
   }

   ImageParticle {
       source: "./particle.png"
       system: particleSystem
//       entryEffect: ImageParticle.Fade
       opacity: 1
       color: "darkblue"
       smooth: true
   }

   Timer
   {
      id: waitingTimer
      interval: 100
      running: false
      repeat: true
      property int times: 0

      onTriggered:
      {
//         times ++
//         waitingText.text = waitingText.text + " ."
      }
      onTimesChanged:
      {
         if (times >= 10)
         {
            times = 0
            waitingText.text = ""
         }
      }
   }
}

