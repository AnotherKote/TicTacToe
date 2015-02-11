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

   Q_PROPERTY(bool myProperty READ getTestProperty WRITE setTestProperty)
public:
   MyCoolTTT(QWidget *parent = 0);
   ~MyCoolTTT();

   Q_INVOKABLE void requestToStartGame (QString opponentAdr);
   void setRootObjects(QList<QObject*> rootObjects);
   bool getTestProperty()
   {
      return testProperty;
   }
   void setTestProperty(bool value)
   {
      testProperty = value;
   }

private slots:   
   void broadcastReadyToPlay();
   void processDatagrams();
//   void sendRequestToStartGame();

private:
   void addToList(QString adr);
   void startGame();

   QUdpSocket *m_pUdpSocket;
   QTimer *m_pTimer;
   QList<QHostAddress> m_lOwnerAddresses;
   QStringList m_lPlayersOnline;

   QList<QObject*> m_pRootObjects;

   const QByteArray m_readyToPlayData;
   const QByteArray m_startGameData;
   const QByteArray m_responseStartGameTrue;
   const QByteArray m_responseStartGameFalse;

   QString m_requestedOpponentAddress;

   bool testProperty;
};

inline void MyCoolTTT::setRootObjects(QList<QObject *> rootObjects)
{
   m_pRootObjects = rootObjects;
}

#endif // MYCOOLTTT_HPP
