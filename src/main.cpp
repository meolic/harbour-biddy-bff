// Copyright (C) 2024 Robert Meolic, SI-2000 Maribor, Slovenia.

// biddy-bff is free software; you can redistribute it and/or modify it under the terms
// of the GNU General Public License as published by the Free Software Foundation;
// either version 2 of the License, or (at your option) any later version.

// biddy-bff is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
// PARTICULAR PURPOSE. See the GNU General Public License for more details.

// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51 Franklin
// Street, Fifth Floor, Boston, MA 02110-1301 USA.

// REQUIREMENTS ON UBUNTU 18.04
// zlib1g-dev
// libgl1-mesa-dev
//
// to update Biddy from the SVN repository:
//
//svn export --force svn://svn.savannah.nongnu.org/biddy/biddy.h
//svn export --force svn://svn.savannah.nongnu.org/biddy/biddyInt.h
//svn export --force svn://svn.savannah.nongnu.org/biddy/biddyMain.c
//svn export --force svn://svn.savannah.nongnu.org/biddy/biddyOp.c
//svn export --force svn://svn.savannah.nongnu.org/biddy/biddyStat.c
//svn export --force svn://svn.savannah.nongnu.org/biddy/biddyInOut.c
//
// either
// change biddInt.h to define COMPACT
// or
// add the following line to the end of file *.pro:
// unix|win32: LIBS += -lgmp

#define SAILFISHAPP
//#define FELGOAPP

#ifdef SAILFISHAPP
#   include <sailfishapp.h>
#   include <QGuiApplication>
#   include <QQuickView>
#   include <QQmlContext>
#endif

#ifdef FELGOAPP
#   include <QApplication>
#   include <QQmlApplicationEngine>
#   include <FelgoApplication>
#   include <QQmlContext>
#endif

#include "booleanfunction.h"
#include "truthtablemodel.h"
#include "karnaughmapmodel.h"
#include "implicantcirclemodel.h"
#include "coveringtablemodel.h"

int main(int argc, char *argv[])
{

    initBdd();
    BooleanFunction *booleanFunction = new BooleanFunction(); // created only once, thes reused everytime, even if num variables changes
    TruthTableModel *truthTableModel = new TruthTableModel(nullptr,booleanFunction);
    ImplicantCircleModel *implicantCircleModel = new ImplicantCircleModel(nullptr,booleanFunction);
    KarnaughMapModel *karnaughMapModel = new KarnaughMapModel(nullptr,booleanFunction);
    CoveringTableModel *coveringTableModel = new CoveringTableModel(nullptr,booleanFunction);

    // any change in truthTableModel is signalised to implicantCircleModel, karnaughMapModel, and coveringTableModel
    QObject::connect(truthTableModel,SIGNAL(modelChanged()),implicantCircleModel,SLOT(onModelChanged()));
    QObject::connect(truthTableModel,SIGNAL(modelChanged()),karnaughMapModel,SLOT(onModelChanged()));
    QObject::connect(truthTableModel,SIGNAL(modelChanged()),coveringTableModel,SLOT(onModelChanged()));

    // any change in karnaughMapModel is signalised to truthTableModel, implicantCircleModel, and coveringTableModel
    QObject::connect(karnaughMapModel,SIGNAL(modelChanged()),truthTableModel,SLOT(onModelChanged()));
    QObject::connect(karnaughMapModel,SIGNAL(modelChanged()),implicantCircleModel,SLOT(onModelChanged()));
    QObject::connect(karnaughMapModel,SIGNAL(modelChanged()),coveringTableModel,SLOT(onModelChanged()));

    // any change in coveringTableModel is signalised to truthTableModel, implicationCircleModel, and karnaughMapModel
    QObject::connect(coveringTableModel,SIGNAL(modelChanged()),truthTableModel,SLOT(onModelChanged()));
    QObject::connect(coveringTableModel,SIGNAL(modelChanged()),implicantCircleModel,SLOT(onModelChanged()));
    QObject::connect(coveringTableModel,SIGNAL(modelChanged()),karnaughMapModel,SLOT(onModelChanged()));

#ifdef SAILFISHAPP

    // SAILFISH - SIMPLE
    //return SailfishApp::main(argc, argv); //display "qml/Main.qml", only

    // SAILFISH - PRODUCTION
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> viewer(SailfishApp::createView());
    viewer.data()->rootContext()->setContextProperty(QStringLiteral("truthTableModel"), truthTableModel);
    viewer.data()->rootContext()->setContextProperty(QStringLiteral("implicantCircleModel"), implicantCircleModel);
    viewer.data()->rootContext()->setContextProperty(QStringLiteral("karnaughMapModel"), karnaughMapModel);
    viewer.data()->rootContext()->setContextProperty(QStringLiteral("coveringTableModel"), coveringTableModel);
    viewer->setSource(SailfishApp::pathTo("qml/Main.qml"));
    viewer->show();
    return app->exec();

#endif

#ifdef FELGOAPP

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    FelgoApplication felgo;

    felgo.setPreservePlatformFonts(true); // Use platform-specific fonts instead of Felgo's default font
    felgo.setLicenseKey(PRODUCT_LICENSE_KEY); // Set an optional license key from project file
    felgo.initialize(&engine);
    engine.rootContext()->setContextProperty(QStringLiteral("truthTableModel"), truthTableModel);
    engine.rootContext()->setContextProperty(QStringLiteral("implicantCircleModel"), implicantCircleModel);
    engine.rootContext()->setContextProperty(QStringLiteral("karnaughMapModel"), karnaughMapModel);
    engine.rootContext()->setContextProperty(QStringLiteral("coveringTableModel"), coveringTableModel);
    felgo.setMainQmlFileName(QStringLiteral("qml/Main.qml")); // use this for DEVELOPMENT
    //felgo.setMainQmlFileName(QStringLiteral("qrc:/qml/Main.qml")); // use this for PUBLISHING
    engine.load(QUrl(felgo.mainQmlFileName()));
    return app.exec();

#endif

    exitBdd();

}
