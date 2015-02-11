#include <QtWidgets>
#include <QtNetwork>

#include "MyCoolTTT.hpp"

#include <QDebug>

MyCoolTTT::MyCoolTTT(QWidget *parent)
: QWidget(parent)
, m_readyToPlayData("Ready to play")
, m_startGameData("Wanna play a little game?")
, m_responseStartGameTrue("Yes")
, m_responseStartGameFalse("No")
, m_requestedOpponentAddress("")
{
   m_pUdpSocket = new QUdpSocket(this);
   m_pUdpSocket->bind(45454, QUdpSocket::ShareAddress);

   m_pTimer = new QTimer(this);

   connect(m_pTimer, &QTimer::timeout, this, &MyCoolTTT::broadcastReadyToPlay);
   connect(m_pUdpSocket, &QUdpSocket::readyRead, this, &MyCoolTTT::processDatagrams);

   QHostInfo info;
   QString qstr = info.localHostName();
   QHostInfo info2 ( QHostInfo ::fromName ( qstr ) );
   m_lOwnerAddresses = info2.addresses();

   m_pTimer->start(1000);
   qDebug() << "start";
}

MyCoolTTT::~MyCoolTTT()
{

}

void MyCoolTTT::requestToStartGame(QString opponentAdr)
{
   m_requestedOpponentAddress = opponentAdr;
   m_pUdpSocket->writeDatagram(m_startGameData.data(), m_startGameData.size(), QHostAddress(m_requestedOpponentAddress), 45454);
   ///[2]Test
//   startGame();
   ///[2]
}

void MyCoolTTT::broadcastReadyToPlay()
{

//   QByteArray datagram = "ReadyToPlay";
   m_pUdpSocket->writeDatagram(m_readyToPlayData.data(), m_readyToPlayData.size(),
                            QHostAddress::LocalHost/*Broadcast*/, 45454);
}


//void MyCoolTTT::sendRequestToStartGame()
//{
////   QByteArray datagram = "WannaPlay";
//   m_pUdpSocket->writeDatagram(m_startGameData.data(), m_startGameData.size(),
//                            QHostAddress::LocalHost/*Broadcast*/, 45454);
//   ///<@todo openWaiting popup
//}

void MyCoolTTT::addToList(QString adr)
{
   qDebug() << "add To list";
   m_lPlayersOnline.append(adr);
   for(QObject* it: m_pRootObjects)
   {
      QObject *list = it->findChild<QObject*>("onlinePlayersList");
      if(list)
      {
         qDebug() << list->objectName();
         QVariant returnedValue;
         QVariant msg = adr;
         QMetaObject::invokeMethod(list,
                                   "addToList",
                                   Q_RETURN_ARG(QVariant, returnedValue),
                                   Q_ARG(QVariant, msg));
      }
   }
}

void MyCoolTTT::startGame()
{
   m_pUdpSocket->close();
   ///<@todo start tcp server
   /// waitfor connection
   for(QObject* it: m_pRootObjects)
   {
      if(it->objectName() == "mainWindow")
      {
         it->setProperty("isStartsFirst", QVariant(true));  ///makeRandom
         it->setProperty("state", QVariant("playGameScreen"));
         break;
      }
   }
}

void MyCoolTTT::processDatagrams()
{
   while (m_pUdpSocket->hasPendingDatagrams())
   {
      QByteArray datagram;
      datagram.resize(m_pUdpSocket->pendingDatagramSize());
      QHostAddress adr;
      m_pUdpSocket->readDatagram(datagram.data(), datagram.size(), &adr);
      qDebug() << datagram.data();
      bool bIsOwnerRequest = false;
      for(const QHostAddress &ownAdr: m_lOwnerAddresses)
      {
         if(adr == ownAdr)
         {
            bIsOwnerRequest = true;
            break;
         }
      }

////[1] for test on one PC
//      if (adr == QHostAddress::LocalHost)
//      {
//         bIsOwnerRequest = true;
//      }
////[1] for test on one PC

      if (!bIsOwnerRequest)
      {
         if( m_readyToPlayData == datagram.data() )
         {
            ///<@todo addToList
            addToList(adr.toString());
         }
         else if( m_startGameData == datagram.data() )
         {
            ///<@todo request to user to start game with adr
         }else if( m_responseStartGameTrue == datagram.data() )
         {
            if(adr.toString() == m_requestedOpponentAddress)
            {
            }
         }else if( m_responseStartGameFalse == datagram.data() )
         {
            if(adr.toString() == m_requestedOpponentAddress)
            {
               ///<@todo closeWaitingPopup
            }
         }else
         {
            qDebug() << "other" << datagram.data() << " " << adr.toString();
         }
      }
      qDebug() << datagram.data() << " " << adr.toString() << " is owner " << bIsOwnerRequest;
   }
}

