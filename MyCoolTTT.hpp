#ifndef MYCOOLTTT_HPP
#define MYCOOLTTT_HPP

#include <QWidget>

QT_BEGIN_NAMESPACE
class QUdpSocket;
class QTimer;
class QHostAddress;
QT_END_NAMESPACE

class MyCoolTTT : public QWidget
{
   Q_OBJECT

   Q_PROPERTY(int popupAnswer MEMBER m_popupAnswer/*READ getPopupAnswer WRITE setPopupAnswer*/ NOTIFY popupAnswerChangedSignal)
public:
   MyCoolTTT(QWidget *parent = 0);
   ~MyCoolTTT();

   Q_INVOKABLE void requestToStartGame (QString opponentAdr);
   Q_INVOKABLE void makeMove (int move);
   Q_INVOKABLE void returnToList ();
   void setRootObjects(QList<QObject*> rootObjects);
   int getPopupAnswer()
   {
      return m_popupAnswer;
   }
   void setPopupAnswer(bool value)
   {
      m_popupAnswer = value;
   }
signals:
   void popupAnswerChangedSignal(int);

private slots:   
   void answerOnRequestSlot();
   void broadcastReadyToPlay();
   void processDatagrams();
   void processGameDatagrams();
//   void sendRequestToStartGame();

private:
   void addToList(QString adr);
   void startGame(bool isServer);

   QUdpSocket *m_pUdpConnectionSocket;
   QUdpSocket *m_pUdpGameSocket;
   QTimer *m_pTimer;
   QList<QHostAddress> m_lOwnerAddresses;
   QStringList m_lPlayersOnline;

   QList<QObject*> m_pRootObjects;
   QObject* m_pQmlMainWindow;
   const QByteArray m_readyToPlayData;
   const QByteArray m_startGameData;
   const QByteArray m_responseStartGameTrue;
   const QByteArray m_responseStartGameFalse;

   QString m_requestedOpponentAddress;
   bool findMainWindow();
   int m_popupAnswer;
};

inline void MyCoolTTT::setRootObjects(QList<QObject *> rootObjects)
{
   m_pRootObjects = rootObjects;
}

#endif // MYCOOLTTT_HPP
