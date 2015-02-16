#include <QtWidgets>
#include <QtNetwork>

#include "MyCoolTTT.hpp"

#include <QDebug>

MyCoolTTT::MyCoolTTT(QWidget *parent)
: QWidget(parent)
, m_pQmlMainWindow(nullptr)
, m_readyToPlayData("Ready to play")
, m_startGameData("Wanna play a little game?")
, m_responseStartGameTrue("Yes")
, m_responseStartGameFalse("No")
, m_requestedOpponentAddress("")
{
   m_pUdpConnectionSocket = new QUdpSocket(this);
   m_pUdpGameSocket = new QUdpSocket(this);

   m_pUdpConnectionSocket->bind(45454, QUdpSocket::ShareAddress);
   m_pUdpGameSocket->bind(54545, QUdpSocket::ShareAddress);

   m_pTimer = new QTimer(this);

   connect(m_pTimer, &QTimer::timeout, this, &MyCoolTTT::broadcastReadyToPlay);
   connect(m_pUdpConnectionSocket, &QUdpSocket::readyRead, this, &MyCoolTTT::processDatagrams);
   connect(this, &MyCoolTTT::popupAnswerChangedSignal, &MyCoolTTT::answerOnRequestSlot);

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
   m_pUdpConnectionSocket->writeDatagram(m_startGameData.data(), m_startGameData.size(), QHostAddress(m_requestedOpponentAddress), 45454);
}

void MyCoolTTT::answerOnRequestSlot()
{
   qDebug() << "C++ answer " << m_popupAnswer << " to " << m_requestedOpponentAddress;
   if(m_popupAnswer == 1)
   {
      m_pUdpConnectionSocket->writeDatagram(m_responseStartGameTrue.data(), m_responseStartGameTrue.size(), QHostAddress(m_requestedOpponentAddress), 45454);
      startGame(false);
   } else if (m_popupAnswer == 2)
   {
      m_pUdpConnectionSocket->writeDatagram(m_responseStartGameFalse.data(), m_responseStartGameFalse.size(), QHostAddress(m_requestedOpponentAddress), 45454);
      if(!m_pQmlMainWindow)
      {
         findMainWindow();
      }
      if(m_pQmlMainWindow)
      {
         m_pQmlMainWindow->setProperty("state", QVariant("playersListScreen"));
      }
   }
   m_popupAnswer = 0;
}

void MyCoolTTT::broadcastReadyToPlay()
{

   m_pUdpConnectionSocket->writeDatagram(m_readyToPlayData.data(), m_readyToPlayData.size(),
                            /*QHostAddress::LocalHost*/QHostAddress::Broadcast, 45454);
}

void MyCoolTTT::addToList(QString adr)
{
   qDebug() << "add To list";
   if(!m_lPlayersOnline.contains(adr, Qt::CaseInsensitive))
   {
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
}

void MyCoolTTT::startGame(bool isServer)
{
   m_pUdpConnectionSocket->close();
   m_pTimer->stop();
   m_pUdpGameSocket->bind(54545, QUdpSocket::ShareAddress);
   connect(m_pUdpGameSocket, &QUdpSocket::readyRead, this, &MyCoolTTT::processGameDatagrams);

   if(!m_pQmlMainWindow)
   {
      findMainWindow();
   }
   if(m_pQmlMainWindow)
   {
      m_pQmlMainWindow->setProperty("isStartsFirst", QVariant(isServer));  ///makeRandom
      m_pQmlMainWindow->setProperty("state", QVariant("playGameScreen"));
   }
//   for(QObject* it: m_pRootObjects)
//   {
//      if(it->objectName() == "mainWindow")
//      {
//         it->setProperty("isStartsFirst", QVariant(isServer));  ///makeRandom
//         it->setProperty("state", QVariant("playGameScreen"));
//         break;
//      }
//   }
}

bool MyCoolTTT::findMainWindow()
{
   qDebug() << "MyCoolTTT::findMainWindow()";
   for(QObject* it: m_pRootObjects)
   {
      if(it->objectName() == "mainWindow")
      {
         m_pQmlMainWindow = it;
         break;
      }
   }
   return (bool)m_pQmlMainWindow;
}

void MyCoolTTT::makeMove(int move)
{
   qDebug() << "out move " << move;
   m_pUdpGameSocket->writeDatagram(QByteArray::number(move), QHostAddress(m_requestedOpponentAddress), 54545);
}

void MyCoolTTT::returnToList()
{
   m_pUdpGameSocket->close();
   m_lPlayersOnline.clear();
   m_pUdpConnectionSocket->bind(45454, QUdpSocket::ShareAddress);
   m_pTimer->start(1000);
}

void MyCoolTTT::processDatagrams()
{
   while (m_pUdpConnectionSocket->hasPendingDatagrams())
   {
      QByteArray datagram;
      datagram.resize(m_pUdpConnectionSocket->pendingDatagramSize());
      QHostAddress adr;
      m_pUdpConnectionSocket->readDatagram(datagram.data(), datagram.size(), &adr);
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

//[1] for test on one PC
      if (adr == QHostAddress::LocalHost)
      {
         bIsOwnerRequest = true;
      }
//[1] for test on one PC

      if (!bIsOwnerRequest)
      {
         if( m_readyToPlayData == datagram.data() )
         {
            addToList(adr.toString());
         }
         else if( m_startGameData == datagram.data() )
         {
            m_requestedOpponentAddress = adr.toString();
            for(QObject* it: m_pRootObjects)
            {
               QObject *popup = it->findChild<QObject*>("waitPopup");
               if(popup)
               {
                  popup->setProperty("text", QVariant("Play with <br> " + m_requestedOpponentAddress + "?"));
                  ///<@todo replace with class member pointer to mainWindow
//                  for(QObject* it: m_pRootObjects)
//                  {
//                     if(it->objectName() == "mainWindow")
//                     {
//                        it->setProperty("state", QVariant("requestToPlayGamePopup"));
//                        break;
//                     }
//                  }
                  if(!m_pQmlMainWindow)
                  {
                     findMainWindow();
                  }
                  if(m_pQmlMainWindow)
                  {
                     m_pQmlMainWindow->setProperty("state", QVariant("requestToPlayGamePopup"));
                  }
                  break;
               }
            }
         }else if( m_responseStartGameTrue == datagram.data() )
         {
            if(adr.toString() == m_requestedOpponentAddress)
            {
               startGame(true);
               qDebug() << "play";
            }
         }else if( m_responseStartGameFalse == datagram.data() )
         {
            if(adr.toString() == m_requestedOpponentAddress)
            {
//               ///<@todo closeWaitingPopup change to List
//               qDebug() << "don't play";
               if(!m_pQmlMainWindow)
               {
                  findMainWindow();
               }
               if(m_pQmlMainWindow)
               {
                  m_pQmlMainWindow->setProperty("state", QVariant("playersListScreen"));
               }
            }
         }else
         {
//            qDebug() << "other" << datagram.data() << " " << adr.toString();
         }
      }
//      qDebug() << datagram.data() << " " << adr.toString() << " is owner " << bIsOwnerRequest;
   }
}

void MyCoolTTT::processGameDatagrams()
{
   while (m_pUdpGameSocket->hasPendingDatagrams())
   {
      QByteArray datagram;
      datagram.resize(m_pUdpGameSocket->pendingDatagramSize());
      QHostAddress adr;
      m_pUdpGameSocket->readDatagram(datagram.data(), datagram.size(), &adr);

      int nextStep = QByteArray(datagram.data()).toInt();
      if(nextStep >= 0 && nextStep <=8)
      {
         ///<@todo replace with class member pointer to mainWindow
//         for(QObject* it: m_pRootObjects)
//         {
//            if(it->objectName() == "mainWindow")
//            {
         if(!m_pQmlMainWindow)
         {
            findMainWindow();
         }
         if(m_pQmlMainWindow)
         {
               m_pQmlMainWindow->setProperty("inMove", QVariant(nextStep));
         }
//               break;
//            }
//         }
      }
      qDebug() << "Data: " << QByteArray(datagram.data()).toInt() << " Adr:" << adr.toString();
   }
}

