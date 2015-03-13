#include "CNetworkManager.hpp"
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlComponent>
#include <QDebug>

int main(int argc, char *argv[])
{
   QApplication a(argc, argv);

//   qmlRegisterType<CNetworkManager>("CNetworkManager", 1, 0, "CNetworkManager");

   QQmlApplicationEngine engine;
   engine.load(QUrl(QStringLiteral("qrc:/PlayersList.qml")));
   CNetworkManager w;
   w.setRootObjects(engine.rootObjects());
   engine.rootContext()->setContextProperty("cNetworkManager", &w);

   return a.exec();
}
