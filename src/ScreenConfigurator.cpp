#include "ScreenConfigurator.h"

ScreenConfigurator::ScreenConfigurator() {
  qDebug() << "here";
  parser = new KScreenDoctorParser();
  _displays = parser->parseDisplays();

  //   qDebug() << displays;
  for (KDisplay *d : _displays) {
    // _displays << d;
    qDebug() << d->name();
  }
}