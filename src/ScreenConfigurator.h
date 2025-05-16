#ifndef SCREENCONFIGURATOR_H
#define SCREENCONFIGURATOR_H

#include "kScreenDoctorParser.h"
#include <QEventPoint>
#include <QGuiApplication>
#include <QList>
#include <QPointer>
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

  Q_INVOKABLE bool displaysIntersecting(QRectF display1, QRectF display2) {
    return display1.intersects(display2);
  };

  Q_INVOKABLE QRectF displayIntersection(QRectF display1, QRectF display2) {
    return display1.intersected(display2);
  };

  Q_INVOKABLE void handlePositionChange(QEventPoint point);
signals:
  void displaysChanged();

private:
  QList<KDisplay *> _displays;
};

#endif