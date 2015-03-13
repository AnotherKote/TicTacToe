#-------------------------------------------------
#
# Project created by QtCreator 2015-02-09T10:37:29
#
#-------------------------------------------------

QT       += network qml quick

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = TTT
TEMPLATE = app
CONFIG += c++11

SOURCES += main.cpp\
        CNetworkManager.cpp

HEADERS  += CNetworkManager.hpp

RESOURCES += \
    qml.qrc
