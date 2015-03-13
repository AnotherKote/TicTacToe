#include <QtWidgets>
#include <QtNetwork>

#include "CNetworkManager.hpp"
#include <QDebug>

CNetworkManager::CNetworkManager(QWidget *parent)
: QWidget(parent)
, mp_QmlMainWindow(nullptr)
, m_readyToPlayData("Ready to play")
, m_startGameData("Wanna play a little game?")
, m_responseStartGameTrue("Yes")
, m_responseStartGameFalse("No")
{
   mp_UdpSocket = new QUdpSocket(this);

   quint16 port = START_PORT_NUM;
   while(!mp_UdpSocket->bind(port, QUdpSocket::ShareAddress) )
   {
      port++;
      if(port >= MAX_PORT_NUM)
      {
         qDebug() << "Binding failed. All ports are busy.";
         break;
      }
   }

   mp_Timer = new QTimer(this);

   connect(mp_Timer, &QTimer::timeout, this, &CNetworkManager::broadcastReadyToPlay);
   connect(mp_UdpSocket, &QUdpSocket::readyRead, this, &CNetworkManager::processDatagrams);
//   connect(this, &CNetworkManager::popupAnswerChangedSignal, &CNetworkManager::answerOnRequestSlot);

   m_lOwnerAddresses = QHostInfo( QHostInfo::fromName( QHostInfo::localHostName() ) ).addresses();

   mp_Timer->start(1000);
}

CNetworkManager::~CNetworkManager()
{

}

void CNetworkManager::requestToStartGame(QString opponentAdr)
{
   QStringList addressAndPort = opponentAdr.split(":");
   if(addressAndPort.size() == 2)
   {
      m_opponentAddress.setAddress(addressAndPort[0]);
      m_opponentPort = addressAndPort[1].toShort();
      qDebug() << "opponent address" << m_opponentAddress << ":" << m_opponentPort;

      QByteArray data;
      QDataStream stream(&data, QIODevice::WriteOnly);
      stream << quint32(eStates::REQUEST_TO_PLAY_GAME);

      mp_UdpSocket->writeDatagram(data, m_opponentAddress, m_opponentPort);
   }
}

void CNetworkManager::answerOnRequestSlot(QVariant answer)
{
   QByteArray data;
   QDataStream stream(&data, QIODevice::WriteOnly);
   if(answer.toInt() == 1)
   {
      stream << quint32(eStates::ACCEPT);
      mp_UdpSocket->writeDatagram(data, m_opponentAddress, m_opponentPort);
      startGame(false);
   } else if (answer.toInt() == 2)
   {
      stream << quint32(eStates::REJECT);
      mp_UdpSocket->writeDatagram(data, m_opponentAddress, m_opponentPort);
      emit changeState("playersListScreen");
   }
   m_popupAnswer = 0;
}

void CNetworkManager::broadcastReadyToPlay()
{
   QByteArray data;
   QDataStream stream(&data, QIODevice::WriteOnly);
   stream << quint32(eStates::READY);

   for (quint16 port = START_PORT_NUM; port < MAX_PORT_NUM; ++port)
   {
      mp_UdpSocket->writeDatagram(data, QHostAddress::Broadcast, port);

   }
}

void CNetworkManager::addToList(QString adr)
{
   qDebug() << "add To list: " << adr;
//   if(!m_lPlayersOnline.contains(adr, Qt::CaseInsensitive))
//   {
//      m_lPlayersOnline.append(adr);
      emit addPlayerToList(adr);
//   }
}

void CNetworkManager::startGame(bool isServer)
{
   mp_Timer->stop();
   emit isStartsFirst(isServer);
   emit changeState("playGameScreen");
}

void CNetworkManager::makeOuterMove(int move)
{
   qDebug() << "out move " << move;

   QByteArray data;
   QDataStream stream(&data, QIODevice::WriteOnly);
   stream << quint32(eStates::GAME_IN_PROGRESS) << qint32(move);

   mp_UdpSocket->writeDatagram(data, m_opponentAddress, m_opponentPort);
}

void CNetworkManager::startBroadcasting(QVariant start)
{
//   m_lPlayersOnline.clear();
   if(start.toBool())
   {
      mp_Timer->start(1000);
   } else
   {
      mp_Timer->stop();
   }
}

void CNetworkManager::setRootObjects(QList<QObject *> rootObjects)
{
   mp_RootObjects = rootObjects;
   mp_QmlMainWindow = rootObjects.first();

   if(mp_QmlMainWindow)
   {
      connect(mp_QmlMainWindow, SIGNAL(popupAnswer(QVariant)), this, SLOT(answerOnRequestSlot(QVariant)));
      connect(mp_QmlMainWindow, SIGNAL(startBroadcasting(QVariant)), this, SLOT(startBroadcasting(QVariant)));
   }
}

void CNetworkManager::processDatagrams()
{
   while (mp_UdpSocket->hasPendingDatagrams())
   {
      QByteArray datagram;
      datagram.resize(mp_UdpSocket->pendingDatagramSize());
      QHostAddress senderAddress;
      quint16 senderPort;
      mp_UdpSocket->readDatagram(datagram.data(), datagram.size(), &senderAddress, &senderPort);

      QDataStream datagramDataStream (&datagram, QIODevice::ReadOnly);

      bool bIsOwnerRequest = false;

      for(const QHostAddress &ownsenderAddress: m_lOwnerAddresses)
      {
         if(senderAddress.toString().append(senderPort) == ownsenderAddress.toString().append(mp_UdpSocket->localPort()))
         {
            bIsOwnerRequest = true;
            break;
         }
      }

      qDebug() << "data " << datagram.data() << " size " << datagram.size() << " senderAddress " << senderAddress.toString() << ":" << senderPort << " isOwner: " << bIsOwnerRequest;

      if (!bIsOwnerRequest)
      {
         quint32 state;
         datagramDataStream >> state;
         switch(state)
         {
         case READY:
            qDebug() << "State: READY";
//            emit addPlayerToList(senderAddress.toString() + ":" + QString::number(senderPort));
            addToList(senderAddress.toString() + ":" + QString::number(senderPort));
            break;
         case REQUEST_TO_PLAY_GAME:
            qDebug() << "State: REQUEST_TO_PLAY_GAME";

            m_opponentAddress = senderAddress;
            m_opponentPort = senderPort;

            emit showRequestToPlayGamePopup(m_opponentAddress.toString() + ":" + QString::number(m_opponentPort));
            break;
         case ACCEPT:
            qDebug() << "State: ACCEPT";
            if(senderAddress == m_opponentAddress && senderPort == m_opponentPort)
            {
               startGame(true);
            }
            break;
         case REJECT:
            qDebug() << "State: REJECT";
            if(senderAddress == m_opponentAddress && senderPort == m_opponentPort)
            {
               emit changeState("playersListScreen");
            }
            break;
         case GAME_IN_PROGRESS:
            qDebug() << "State: GAME_IN_PROGRESS";

            int nextMove;
            datagramDataStream >> nextMove;
            qDebug() << "nextMove: " << nextMove;

            if(nextMove >= 0 && nextMove <=8)
            {
               emit makeInnerMove(nextMove);
            }
            break;
         case MSG:
            qDebug() << "State: MSG";
            break;
         default:
            break;
         }
      }
   }
}
