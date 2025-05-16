#ifndef KDISPLAY_H
#define KDISPLAY_H

#include <QGuiApplication>
#include <QJsonArray>
#include <ostream>

class KDisplay : public QObject {
  Q_OBJECT
  Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
  // Q_PROPERTY(std::pair<int, int> pos READ pos WRITE setPos)
  // Q_PROPERTY(std::pair<int, int> size READ size WRITE setSize)
  Q_PROPERTY(QPoint pos READ pos WRITE setPos NOTIFY posChanged)
  Q_PROPERTY(QSize size READ size WRITE setSize NOTIFY sizeChanged)
public:
  KDisplay();
  // operator std::string() const { return "Display: " + _name.toStdString(); }
  // operator QString() const { return QString("Display: %1\n").arg(_name); }

  // QDebug operator<<(QDebug dbg) //, const QDataflowModelOutlet &outlet)
  // {
  //   QDebugStateSaver stateSaver(dbg);
  //   dbg.nospace() << "test";
  //   return dbg;
  // }

  int id;
  QString name() { return _name; }
  QPoint pos() { return _pos; }
  QSize size() { return _size; }

  void setName(QString name) { _name = name; }
  void setPos(QPoint pos) { _pos = pos; }
  void setSize(QSize size) { _size = size; }

  bool connected;
  bool enabled;
  QString currentModeId;
  QJsonArray modes;

signals:
  void nameChanged();
  void posChanged();
  void sizeChanged();

private:
  QString _name;
  QPoint _pos;
  QSize _size;
};

inline QDebug operator<<(QDebug dbg, KDisplay &display) {
  QDebugStateSaver stateSaver(dbg);
  dbg.nospace().noquote() << "Display: " << display.name() << "\n";
  dbg.nospace().noquote() << "Position: " << display.pos() << "\n";
  dbg.nospace().noquote() << "Size: " << display.size() << "\n";
  return dbg;
}

#endif
