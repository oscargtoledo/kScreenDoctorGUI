#ifndef KSCREENDOCTORPARSER_H
#define KSCREENDOCTORPARSER_H

#include "KDisplay.h"
#include <QGuiApplication>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QProcess>

class KScreenDoctorParser : public QObject {
  Q_OBJECT
  Q_PROPERTY(int monitorAmount READ monitorAmount WRITE setMonitorAmount)

public:
  KScreenDoctorParser();
  int monitorAmount() { return _monitorAmount; }
  void setMonitorAmount(int amount) { _monitorAmount = amount; }

  QList<KDisplay *> parseDisplays();

private:
  int _monitorAmount = 1;

  QString _kScreenDoctorProgram = "kscreen-doctor";
  QJsonDocument _lastDoctorOutput;
};

#endif