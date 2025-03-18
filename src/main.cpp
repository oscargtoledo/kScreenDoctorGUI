#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "ScreenConfigurator.h"
#include "kScreenDoctorParser.h"

int main(int argc, char *argv[]) {
  QGuiApplication app(argc, argv);

  QQmlApplicationEngine engine;

  qmlRegisterSingletonType<ScreenConfigurator>(
      "ScreenConfigurator", 1, 0, "ScreenConfigurator",
      [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        ScreenConfigurator *example = new ScreenConfigurator();
        return example;
      });

  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreationFailed, &app,
      []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
  engine.loadFromModule("kScreenDoctorGUI", "Main");

  return app.exec();
}
