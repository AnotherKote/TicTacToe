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

public:
   MyCoolTTT(QWidget *parent = 0);
   ~MyCoolTTT();

   Q_INVOKABLE void requestToStartGame (QString opponentAdr);
   void setRootObjects(QList<QObject*> rootObjects);


private slots:   
   void broadcastReadyToPlay();
   void processDatagrams();
   void sendRequestToStartGame();

private:
   QUdpSocket *m_pUdpSocket;
   QTimer *m_pTimer;
   QList<QHostAddress> m_lOwnerAddresses;
   QStringList m_lPlayersOnline;

   QList<QObject*> m_pRootObjects;

   const QByteArray m_readyToPlayData;
   const QByteArray m_startGameData;
   const QByteArray m_responseStartGameTrue;
   const QByteArray m_responseStartGameFalse;

   void addToList(QString adr);
};

inline void MyCoolTTT::setRootObjects(QList<QObject *> rootObjects)
{
   m_pRootObjects = rootObjects;
}

#endif // MYCOOLTTT_HPP
