#include "kScreenDoctorParser.h"

KScreenDoctorParser::KScreenDoctorParser() {
  QStringList arguments;
  arguments << "-j";
  QProcess *doctorProcess = new QProcess();

  doctorProcess->start(_kScreenDoctorProgram, arguments);
  // doctorProcess->start("ls");
  doctorProcess->waitForFinished();
  QByteArray result = doctorProcess->readAll();
  QJsonDocument itemDoc = QJsonDocument::fromJson(result);
  _lastDoctorOutput = itemDoc;
  return;
}

QList<KDisplay *> KScreenDoctorParser::parseDisplays() {
  QJsonArray outputs = _lastDoctorOutput.object().value("outputs").toArray();
  QList<KDisplay *> displays;
  for (auto v : outputs) {
    auto obj = v.toObject();
    KDisplay *display = new KDisplay();
    display->setName(obj.value("name").toString());
    displays << display;
  }
  return displays;
}