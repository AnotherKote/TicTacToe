#ifndef CPPINVOKER_H
#define CPPINVOKER_H

#include <QObject>

class CppInvoker : public QObject
{
   Q_OBJECT
public:
   explicit CppInvoker(QObject *parent = 0);
   ~CppInvoker();

signals:

public slots:
};

#endif // CPPINVOKER_H
