#ifndef CNETWORKMANAGER_HPP
#define CNETWORKMANAGER_HPP

#include <QWidget>
#include <QHostAddress>

QT_BEGIN_NAMESPACE
class QUdpSocket;
class QTimer;
class QStringListModel;
QT_END_NAMESPACE

class CNetworkManager : public QWidget
{
   Q_OBJECT

//   Q_PROPERTY(int popupAnswer MEMBER m_popupAnswer/*READ getPopupAnswer WRITE setPopupAnswer*/ NOTIFY popupAnswerChangedSignal)

   static const quint16 START_PORT_NUM = 4000;
   static const quint16 MAX_PORT_NUM   = 4005;

   enum eStates
   {
      READY = 0,
      REQUEST_TO_PLAY_GAME,
      ACCEPT,
      REJECT,
      GAME_IN_PROGRESS,
      MSG
   };

public:
   CNetworkManager(QWidget *parent = 0);
   ~CNetworkManager();

   Q_INVOKABLE void requestToStartGame (QString opponentAdr);
   Q_INVOKABLE void makeOuterMove (int move);

   void setRootObjects(QList<QObject*> rootObjects);

//   QStringListModel& getModel();
//   int getPopupAnswer()
//   {
//      return m_popupAnswer;
//   }
//   void setPopupAnswer(bool value)
//   {
//      m_popupAnswer = value;
//   }
signals:
   void popupAnswerChangedSignal(int);

   void makeInnerMove(int move);
   void changeState(QString state);
   void isStartsFirst(bool bStartsFirst);
   void addPlayerToList(QString playerName);
   void showRequestToPlayGamePopup(QString opponentName);

private slots:   
   void answerOnRequestSlot(QVariant answer);
   void broadcastReadyToPlay();
   void processDatagrams();
   void startBroadcasting(QVariant start);

private:
   void addToList(QString adr);
   void startGame(bool isServer);

   QUdpSocket *mp_UdpSocket;
   QTimer *mp_Timer;
   QList<QHostAddress> m_lOwnerAddresses;
//   QStringListModel m_lPlayersOnline;

   QList<QObject*> mp_RootObjects;
   QObject* mp_QmlMainWindow;
   const QByteArray m_readyToPlayData;
   const QByteArray m_startGameData;
   const QByteArray m_responseStartGameTrue;
   const QByteArray m_responseStartGameFalse;

   QHostAddress  m_opponentAddress;
   quint16       m_opponentPort;

   int m_popupAnswer;
};

//QStringListModel &CNetworkManager::getModel()
//{
//   return m_lPlayersOnline;
//}

#endif // CNETWORKMANAGER_HPP
