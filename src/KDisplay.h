#ifndef KDISPLAY_H
#define KDISPLAY_H

#include <QGuiApplication>
#include <QJsonArray>

class KDisplay : public QObject {
  Q_OBJECT
  Q_PROPERTY(QString name READ name WRITE setName)
public:
  KDisplay();

  int id;
  QString name() { return _name; }
  void setName(QString name) { _name = name; }
  std::pair<int, int> pos;
  bool connected;
  bool enabled;
  QString currentModeId;
  QJsonArray modes;

private:
  QString _name;
};

#endif