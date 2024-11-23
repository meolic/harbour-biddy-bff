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

#include "karnaughmapmodel.h"

#include<QDebug>
#define QT_NO_DEBUG_OUTPUT

// there exists multiple instances of KarnaughMapModel, one for each size of Boolean function

KarnaughMapModel::KarnaughMapModel(QObject *parent, BooleanFunction *bf) : QAbstractListModel(parent)
{
    //qDebug() << "KarnaughMapModel INIT";

    booleanFunction = bf;
    if (booleanFunction->getNumVariables() == 2)
    {
    } else if (booleanFunction->getNumVariables() == 3)
    {
    } else if (booleanFunction->getNumVariables() == 4)
    {
        //qDebug() << "KarnaughMapModel booleanFunction->getNumVariables() == 4";
        for (unsigned int i=0; i<16; i++) elements << " ";
    } else if (booleanFunction->getNumVariables() == 5)
    {
    }
}

KarnaughMapModel::~KarnaughMapModel()
{
}

// requred by QAbstractListModel
int KarnaughMapModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return elements.count();
}

// requred by QAbstractListModel
QVariant KarnaughMapModel::data(const QModelIndex &index, int role) const
{
    // the index returns the requested row and column information.
    // we ignore the column and only use the row information
    int row = index.row();

    // boundary check for the row
    if(row < 0 || row >= elements.count()) {
        return QVariant();
    }

    // A model can return data for different roles.
    // The default role is the display role.
    // it can be accesses in QML with "model.display"
    switch(role) {
        case Qt::DisplayRole:
            // Qt automatically converts returned values to the QVariant type
            return elements.value(row);
    }

    // Asked for other data, just return an empty QVariant
    return QVariant();
}

// refreshCPP is used to refresh C++ structures after changes by GUI
void KarnaughMapModel::refreshCPP()
{
    //qDebug() << "KarnaughMapModel::refreshCPP()";
    //qDebug() << "KarnaughMapModel::refreshCPP() booleanFunction->getNumVariables() == " << booleanFunction->getNumVariables();
    //qDebug() << "KarnaughMapModel::refreshCPP() elements.count() = " << elements.count() << " : " << elements;

    if (booleanFunction->getNumVariables() == 2)
    {
    } else if (booleanFunction->getNumVariables() == 3)
    {
    } else if (booleanFunction->getNumVariables() == 4)
    {
        for (unsigned int i=0; i<16; i++) {
            booleanFunction->setMinterm(i,elements.at(static_cast<int>(KARNAUGH4x4.at(i))).toStdString());
        }
    } else if (booleanFunction->getNumVariables() == 5)
    {
    }
    booleanFunction->update();
    emit modelChanged(); // notifies other classes about the change
}

// onModelChanged() is used to refresh KarnaughMap.qml to reflect the changed model
void KarnaughMapModel::onModelChanged()
{
    //qDebug() << "KarnaughMapModel::onModelChanged()";
    //qDebug() << "KarnaughMapModel::onModelChanged() booleanFunction->getNumVariables() == " << booleanFunction->getNumVariables();
    //qDebug() << "KarnaughMapModel::onModelChanged() elements.count() = " << elements.count() << " : " << elements;

    if (booleanFunction->getNumVariables() == 2)
    {
    } else if (booleanFunction->getNumVariables() == 3)
    {
    } else if (booleanFunction->getNumVariables() == 4)
    {
        for (unsigned int i=0; i<16; i++) {
            elements.replace(static_cast<int>(i),QString::fromStdString(booleanFunction->getMinterm(KARNAUGH4x4.at(i))));
        }
    } else if (booleanFunction->getNumVariables() == 5)
    {
    }
    emit dataChanged(index(0),index(elements.count()-1),{Qt::DisplayRole});
}

// INVOKABLE METHODS

QString KarnaughMapModel::get(const int &row)
{
    if(row < 0 || row >= elements.count()) {
        return QString();
    }
    return elements.at(row);
}

void KarnaughMapModel::setZero(const int &row)
{
    if(row < 0 || row >= elements.count()) return;
    elements[row] = "0";
    emit dataChanged(index(row),index(row),{Qt::DisplayRole});
    refreshCPP();
}

void KarnaughMapModel::setOne(const int &row)
{
    if(row < 0 || row >= elements.count()) return;
    elements[row] = "1";
    emit dataChanged(index(row),index(row),{Qt::DisplayRole});
    refreshCPP();
}

void KarnaughMapModel::setX(const int &row)
{
    if(row < 0 || row >= elements.count()) return;
    elements[row] = "X";
    emit dataChanged(index(row),index(row),{Qt::DisplayRole});
    refreshCPP();
}

void KarnaughMapModel::setEmpty(const int &row)
{
    if(row < 0 || row >= elements.count()) return;
    elements[row] = " ";
    emit dataChanged(index(row),index(row),{Qt::DisplayRole});
    refreshCPP();
}

void KarnaughMapModel::allZero()
{
    if (booleanFunction->getNumVariables() == 2)
    {
    } else if (booleanFunction->getNumVariables() == 3)
    {
    } else if (booleanFunction->getNumVariables() == 4)
    {
        for (int i=0; i<16; i++) elements[i] = "0";
    } else if (booleanFunction->getNumVariables() == 5)
    {
    }
    emit dataChanged(index(0),index(elements.count()-1),{Qt::DisplayRole});
    refreshCPP();
}

void KarnaughMapModel::allOne()
{
    for (int i=0; i<16; i++) elements[i] = "1";
    emit dataChanged(index(0),index(elements.count()-1),{Qt::DisplayRole});
    refreshCPP();
}

void KarnaughMapModel::allEmpty()
{
    if (booleanFunction->getNumVariables() == 2)
    {
    } else if (booleanFunction->getNumVariables() == 3)
    {
    } else if (booleanFunction->getNumVariables() == 4)
    {
        for (int i=0; i<16; i++) elements[i] = " ";
    } else if (booleanFunction->getNumVariables() == 5)
    {
    }
    emit dataChanged(index(0),index(elements.count()-1),{Qt::DisplayRole});
    refreshCPP();
}

void KarnaughMapModel::allRandom()
{
    booleanFunction->makeAllRandom(); // changes are made by C++
    onModelChanged(); // refresh QML elements
    emit modelChanged(); // notifies other classes about the change
}
