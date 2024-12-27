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

#include <sailfishapp.h>
#include <QGuiApplication>
#include <QQuickView>
#include <QQmlContext>

#include "booleanfunction.h"
#include "truthtablemodel.h"
#include "karnaughmapmodel.h"
#include "implicantcirclemodel.h"
#include "coveringtablemodel.h"

int main(int argc, char *argv[])
{

    initBdd();
    BooleanFunction *booleanFunction2 = new BooleanFunction(); // created one function with 2 variables
    booleanFunction2->setNumVariables(2);
    BooleanFunction *booleanFunction3 = new BooleanFunction(); // created one function with 3 variables
    booleanFunction3->setNumVariables(3);
    BooleanFunction *booleanFunction4 = new BooleanFunction(); // created one function with 4 variables
    booleanFunction4->setNumVariables(4);
    BooleanFunction *booleanFunction5 = new BooleanFunction(); // created one function with 5 variables
    booleanFunction5->setNumVariables(5);
    TruthTableModel *truthTableModel2 = new TruthTableModel(nullptr,booleanFunction2);
    TruthTableModel *truthTableModel3 = new TruthTableModel(nullptr,booleanFunction3);
    TruthTableModel *truthTableModel4 = new TruthTableModel(nullptr,booleanFunction4);
    TruthTableModel *truthTableModel5 = new TruthTableModel(nullptr,booleanFunction5);
    ImplicantCircleModel *implicantCircleModel2 = new ImplicantCircleModel(nullptr,booleanFunction2);
    ImplicantCircleModel *implicantCircleModel3 = new ImplicantCircleModel(nullptr,booleanFunction3);
    ImplicantCircleModel *implicantCircleModel4 = new ImplicantCircleModel(nullptr,booleanFunction4);
    ImplicantCircleModel *implicantCircleModel5 = new ImplicantCircleModel(nullptr,booleanFunction5);
    KarnaughMapModel *karnaughMapModel2 = new KarnaughMapModel(nullptr,booleanFunction2);
    KarnaughMapModel *karnaughMapModel3 = new KarnaughMapModel(nullptr,booleanFunction3);
    KarnaughMapModel *karnaughMapModel4 = new KarnaughMapModel(nullptr,booleanFunction4);
    KarnaughMapModel *karnaughMapModel5 = new KarnaughMapModel(nullptr,booleanFunction5);
    CoveringTableModel *coveringTableModel2 = new CoveringTableModel(nullptr,booleanFunction2);
    CoveringTableModel *coveringTableModel3 = new CoveringTableModel(nullptr,booleanFunction3);
    CoveringTableModel *coveringTableModel4 = new CoveringTableModel(nullptr,booleanFunction4);
    CoveringTableModel *coveringTableModel5 = new CoveringTableModel(nullptr,booleanFunction5);

    // any change in truthTableModel is signalised to implicantCircleModel, karnaughMapModel, and coveringTableModel
    QObject::connect(truthTableModel2,SIGNAL(modelChanged()),implicantCircleModel2,SLOT(onModelChanged()));
    QObject::connect(truthTableModel2,SIGNAL(modelChanged()),karnaughMapModel2,SLOT(onModelChanged()));
    QObject::connect(truthTableModel2,SIGNAL(modelChanged()),coveringTableModel2,SLOT(onModelChanged()));

    QObject::connect(truthTableModel3,SIGNAL(modelChanged()),implicantCircleModel3,SLOT(onModelChanged()));
    QObject::connect(truthTableModel3,SIGNAL(modelChanged()),karnaughMapModel3,SLOT(onModelChanged()));
    QObject::connect(truthTableModel3,SIGNAL(modelChanged()),coveringTableModel3,SLOT(onModelChanged()));

    QObject::connect(truthTableModel4,SIGNAL(modelChanged()),implicantCircleModel4,SLOT(onModelChanged()));
    QObject::connect(truthTableModel4,SIGNAL(modelChanged()),karnaughMapModel4,SLOT(onModelChanged()));
    QObject::connect(truthTableModel4,SIGNAL(modelChanged()),coveringTableModel4,SLOT(onModelChanged()));

    QObject::connect(truthTableModel5,SIGNAL(modelChanged()),implicantCircleModel5,SLOT(onModelChanged()));
    QObject::connect(truthTableModel5,SIGNAL(modelChanged()),karnaughMapModel5,SLOT(onModelChanged()));
    QObject::connect(truthTableModel5,SIGNAL(modelChanged()),coveringTableModel5,SLOT(onModelChanged()));

    // any change in karnaughMapModel is signalised to truthTableModel, implicantCircleModel, and coveringTableModel
    QObject::connect(karnaughMapModel2,SIGNAL(modelChanged()),truthTableModel2,SLOT(onModelChanged()));
    QObject::connect(karnaughMapModel2,SIGNAL(modelChanged()),implicantCircleModel2,SLOT(onModelChanged()));
    QObject::connect(karnaughMapModel2,SIGNAL(modelChanged()),coveringTableModel2,SLOT(onModelChanged()));

    QObject::connect(karnaughMapModel3,SIGNAL(modelChanged()),truthTableModel3,SLOT(onModelChanged()));
    QObject::connect(karnaughMapModel3,SIGNAL(modelChanged()),implicantCircleModel3,SLOT(onModelChanged()));
    QObject::connect(karnaughMapModel3,SIGNAL(modelChanged()),coveringTableModel3,SLOT(onModelChanged()));

    QObject::connect(karnaughMapModel4,SIGNAL(modelChanged()),truthTableModel4,SLOT(onModelChanged()));
    QObject::connect(karnaughMapModel4,SIGNAL(modelChanged()),implicantCircleModel4,SLOT(onModelChanged()));
    QObject::connect(karnaughMapModel4,SIGNAL(modelChanged()),coveringTableModel4,SLOT(onModelChanged()));

    QObject::connect(karnaughMapModel5,SIGNAL(modelChanged()),truthTableModel5,SLOT(onModelChanged()));
    QObject::connect(karnaughMapModel5,SIGNAL(modelChanged()),implicantCircleModel5,SLOT(onModelChanged()));
    QObject::connect(karnaughMapModel5,SIGNAL(modelChanged()),coveringTableModel5,SLOT(onModelChanged()));

    // any change in coveringTableModel is signalised to truthTableModel, implicationCircleModel, and karnaughMapModel
    QObject::connect(coveringTableModel2,SIGNAL(modelChanged()),truthTableModel2,SLOT(onModelChanged()));
    QObject::connect(coveringTableModel2,SIGNAL(modelChanged()),implicantCircleModel2,SLOT(onModelChanged()));
    QObject::connect(coveringTableModel2,SIGNAL(modelChanged()),karnaughMapModel2,SLOT(onModelChanged()));

    QObject::connect(coveringTableModel3,SIGNAL(modelChanged()),truthTableModel3,SLOT(onModelChanged()));
    QObject::connect(coveringTableModel3,SIGNAL(modelChanged()),implicantCircleModel3,SLOT(onModelChanged()));
    QObject::connect(coveringTableModel3,SIGNAL(modelChanged()),karnaughMapModel3,SLOT(onModelChanged()));

    QObject::connect(coveringTableModel4,SIGNAL(modelChanged()),truthTableModel4,SLOT(onModelChanged()));
    QObject::connect(coveringTableModel4,SIGNAL(modelChanged()),implicantCircleModel4,SLOT(onModelChanged()));
    QObject::connect(coveringTableModel4,SIGNAL(modelChanged()),karnaughMapModel4,SLOT(onModelChanged()));

    QObject::connect(coveringTableModel5,SIGNAL(modelChanged()),truthTableModel5,SLOT(onModelChanged()));
    QObject::connect(coveringTableModel5,SIGNAL(modelChanged()),implicantCircleModel5,SLOT(onModelChanged()));
    QObject::connect(coveringTableModel5,SIGNAL(modelChanged()),karnaughMapModel5,SLOT(onModelChanged()));

    // SAILFISH - SIMPLE
    //return SailfishApp::main(argc, argv); //display "qml/Main.qml", only

    // SAILFISH - PRODUCTION
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> viewer(SailfishApp::createView());
    viewer.data()->rootContext()->setContextProperty(QStringLiteral("truthTableModel2"), truthTableModel2);
    viewer.data()->rootContext()->setContextProperty(QStringLiteral("truthTableModel3"), truthTableModel3);
    viewer.data()->rootContext()->setContextProperty(QStringLiteral("truthTableModel4"), truthTableModel4);
    viewer.data()->rootContext()->setContextProperty(QStringLiteral("truthTableModel5"), truthTableModel5);
    viewer.data()->rootContext()->setContextProperty(QStringLiteral("implicantCircleModel2"), implicantCircleModel2);
    viewer.data()->rootContext()->setContextProperty(QStringLiteral("implicantCircleModel3"), implicantCircleModel3);
    viewer.data()->rootContext()->setContextProperty(QStringLiteral("implicantCircleModel4"), implicantCircleModel4);
    viewer.data()->rootContext()->setContextProperty(QStringLiteral("implicantCircleModel5"), implicantCircleModel5);
    viewer.data()->rootContext()->setContextProperty(QStringLiteral("karnaughMapModel2"), karnaughMapModel2);
    viewer.data()->rootContext()->setContextProperty(QStringLiteral("karnaughMapModel3"), karnaughMapModel3);
    viewer.data()->rootContext()->setContextProperty(QStringLiteral("karnaughMapModel4"), karnaughMapModel4);
    viewer.data()->rootContext()->setContextProperty(QStringLiteral("karnaughMapModel5"), karnaughMapModel5);
    viewer.data()->rootContext()->setContextProperty(QStringLiteral("coveringTableModel2"), coveringTableModel2);
    viewer.data()->rootContext()->setContextProperty(QStringLiteral("coveringTableModel3"), coveringTableModel3);
    viewer.data()->rootContext()->setContextProperty(QStringLiteral("coveringTableModel4"), coveringTableModel4);
    viewer.data()->rootContext()->setContextProperty(QStringLiteral("coveringTableModel5"), coveringTableModel5);
    viewer->setSource(SailfishApp::pathTo("qml/Main.qml"));
    viewer->show();
    return app->exec();

    exitBdd();

}
