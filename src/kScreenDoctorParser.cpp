#include "kScreenDoctorParser.h"

KScreenDoctorParser::KScreenDoctorParser() {
  QStringList arguments;
  arguments << "-j";
  QProcess *doctorProcess = new QProcess();

  doctorProcess->start(_kScreenDoctorProgram, arguments);
  doctorProcess->waitForFinished();
  if (doctorProcess->exitStatus() == QProcess::CrashExit) {
    qCritical() << "kscreen-doctor execution failed";
    qCritical() << doctorProcess->error();
  }
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
    auto position = obj.value("pos").toObject();

    // display->setPos(std::make_pair<int, int>(position.value("x").toInt(),
    //                                          position.value("y").toInt()));

    // auto size = obj.value("size").toObject();
    // display->setSize(std::make_pair<int, int>(size.value("width").toInt(),
    //                                           size.value("height").toInt()));

    display->setPos(
        QPoint(position.value("x").toInt(), position.value("y").toInt()));

    auto size = obj.value("size").toObject();
    display->setSize(
        QSize(size.value("width").toInt(), size.value("height").toInt()));
    displays << display;
  }
  return displays;
}
