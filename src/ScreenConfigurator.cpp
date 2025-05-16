#include "ScreenConfigurator.h"

ScreenConfigurator::ScreenConfigurator() {
  parser = new KScreenDoctorParser();
  _displays = parser->parseDisplays();

  //   qDebug() << displays;
  for (KDisplay *d : _displays) {
    // _displays << d;
    qDebug() << *d;
  }
}

void ScreenConfigurator::handlePositionChange(QEventPoint point) {}
