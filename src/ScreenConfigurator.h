#ifndef SCREENCONFIGURATOR_H
#define SCREENCONFIGURATOR_H

#include "kScreenDoctorParser.h"
#include <QGuiApplication>
#include <QList>
#include <QQmlEngine>

class ScreenConfigurator : public QObject {
  Q_OBJECT
  Q_PROPERTY(QList<KDisplay *> displays READ getDisplays WRITE setDisplays
                 NOTIFY displaysChanged);

public:
  ScreenConfigurator();
  KScreenDoctorParser *parser;
  Q_INVOKABLE QList<KDisplay *> getDisplays() { return _displays; };
  void setDisplays(QList<KDisplay *> disps) { _displays = disps; }

signals:
  void displaysChanged();

private:
  QList<KDisplay *> _displays;
};

#endif