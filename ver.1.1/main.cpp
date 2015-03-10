#include "MyCoolTTT.hpp"
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlComponent>
#include <QDebug>

int main(int argc, char *argv[])
{
   QApplication a(argc, argv);

//   qmlRegisterType<MyCoolTTT>("MyCoolTTT", 1, 0, "MyCoolTTT");

   QQmlApplicationEngine engine;
   engine.load(QUrl(QStringLiteral("qrc:/PlayersList.qml")));
   MyCoolTTT w;
   w.setRootObjects(engine.rootObjects());
   engine.rootContext()->setContextProperty("onlineListController", &w);

   return a.exec();
}
