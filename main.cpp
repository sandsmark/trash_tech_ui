#include <QGuiApplication>
#include <QQuickView>

int main(int argc, char** argv)
{
    QGuiApplication app(argc, argv);
    QQuickView *view = new QQuickView;
    view->setSource(QUrl("qrc:/detektor_ui.qml"));
    view->showFullScreen();

    return app.exec();
}
