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

#include "truthtablemodel.h"

#include<QDebug>
#define QT_NO_DEBUG_OUTPUT

TruthTableModel::TruthTableModel(QObject *parent, BooleanFunction *bf) : QAbstractListModel(parent)
{
    //qDebug() << "TruthTableModel INIT";

    booleanFunction = bf;
    variableNames << "a" << "b" << "c" << "d" << "e";
    unsigned int i0 = 0;
    unsigned int i1 = 0;
    unsigned int i2 = 0;
    unsigned int i3 = 0;
    unsigned int i4 = 0;
    elements.clear();
    if (booleanFunction->getNumVariables() == 2)
    {
        for (int i=1; i<=4; i++) {
            if (i0 == 0) elements << "0"; else elements << "1"; // legend
            if (i1 == 0) elements << "0"; else elements << "1"; // legend
            elements << " "; // value
            if (i%2 == 0) i0 = 1 - i0;
            if (i%1 == 0) i1 = 1 - i1;
        }
    } else if (booleanFunction->getNumVariables() == 3)
    {
        for (int i=1; i<=9; i++) {
            if (i0 == 0) elements << "0"; else elements << "1"; // legend
            if (i1 == 0) elements << "0"; else elements << "1"; // legend
            if (i2 == 0) elements << "0"; else elements << "1"; // legend
            elements << " "; // value
            if (i%4 == 0) i0 = 1 - i0;
            if (i%2 == 0) i1 = 1 - i1;
            if (i%1 == 0) i2 = 1 - i2;
        }
    } else if (booleanFunction->getNumVariables() == 4)
    {
        //qDebug() << "TruthTableModel booleanFunction->getNumVariables() == 4";
        for (int i=1; i<=16; i++) {
            if (i0 == 0) elements << "0"; else elements << "1"; // legend
            if (i1 == 0) elements << "0"; else elements << "1"; // legend
            if (i2 == 0) elements << "0"; else elements << "1"; // legend
            if (i3 == 0) elements << "0"; else elements << "1"; // legend
            elements << " "; // value
            if (i%8 == 0) i0 = 1 - i0;
            if (i%4 == 0) i1 = 1 - i1;
            if (i%2 == 0) i2 = 1 - i2;
            if (i%1 == 0) i3 = 1 - i3;
        }
    } else if (booleanFunction->getNumVariables() == 5)
    {
        for (int i=1; i<=25; i++) {
            if (i0 == 0) elements << "0"; else elements << "1"; // legend
            if (i1 == 0) elements << "0"; else elements << "1"; // legend
            if (i2 == 0) elements << "0"; else elements << "1"; // legend
            if (i3 == 0) elements << "0"; else elements << "1"; // legend
            if (i4 == 0) elements << "0"; else elements << "1"; // legend
            elements << " "; // value
            if (i%16 == 0) i0 = 1 - i0;
            if (i%8 == 0) i1 = 1 - i1;
            if (i%4 == 0) i2 = 1 - i2;
            if (i%2 == 0) i3 = 1 - i3;
            if (i%1 == 0) i4 = 1 - i4;
        }
    }
}

TruthTableModel::~TruthTableModel()
{
}

// requred by QAbstractListModel
int TruthTableModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return elements.count();
}

// requred by QAbstractListModel
QVariant TruthTableModel::data(const QModelIndex &index, int role) const
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
void TruthTableModel::refreshCPP()
{
    //qDebug() << "TruthTableModel::refreshCPP()";
    qDebug() << "TruthTableModel::refreshCPP() booleanFunction->getNumVariables() == " << booleanFunction->getNumVariables();
    qDebug() << "TruthTableModel::refreshCPP() elements.count() = " << elements.count() << " : " << elements;

    if (booleanFunction->getNumVariables() == 2)
    {
    } else if (booleanFunction->getNumVariables() == 3)
    {
    } else if (booleanFunction->getNumVariables() == 4)
    {
        for (unsigned int i=0; i<16; i++) {
            booleanFunction->setMinterm(i,elements.at(static_cast<int>((4+1)*i+4)).toStdString());
        }
    } else if (booleanFunction->getNumVariables() == 5)
    {
    }

    booleanFunction->update();
    emit modelChanged(); // notifies other classes about the change
}

// onModelChanged() is used to refresh TruthTable.qml to reflect the changed model
void TruthTableModel::onModelChanged()
{
    //qDebug() << "TruthTableModel::onModelChanged()";
    qDebug() << "TruthTableModel::onModelChanged() booleanFunction->getNumVariables() == " << booleanFunction->getNumVariables();
    qDebug() << "TruthTableModel::onModelChanged() elements.count() = " << elements.count() << " : " << elements;

    if (booleanFunction->getNumVariables() == 2)
    {
    } else if (booleanFunction->getNumVariables() == 3)
    {
    } else if (booleanFunction->getNumVariables() == 4)
    {
        for (unsigned int i=0; i<16; i++) {
            elements.replace(static_cast<int>((4+1)*i+4),QString::fromStdString(booleanFunction->getMinterm(i)));
        }
    } else if (booleanFunction->getNumVariables() == 5)
    {
    }
    emit dataChanged(index(0),index(elements.count()-1),{Qt::DisplayRole});
}

// INVOKABLE METHODS

QString TruthTableModel::get(const int &row)
{
    if(row < 0 || row >= elements.count()) {
        return QString();
    }
    return elements.at(row);
}

QString TruthTableModel::string2html(const QString &text)
{
    string vn = "";
    for (auto n: variableNames) {
      vn = vn + n.toStdString();
    }
    return QString::fromStdString(BooleanFunction::string2html(text.toStdString(),vn));
}

QString TruthTableModel::getVariableName(const int &i)
{
    if (i == 0) return "";
    return variableNames.at(i-1);
}

void TruthTableModel::setVariableName(const int&i, const QString &name)
{
    if (i == 0) return;
    if (name == "") return;

    //qDebug() << "TruthTableModel::setVariableName " << name;

    // only the first character in the given name is used
    variableNames[i-1] = name[0];
}

void TruthTableModel::setZero(const int &row)
{
    if(row < 0 || row >= elements.count()) return;
    elements[row] = "0";
    emit dataChanged(index(row),index(row),{Qt::DisplayRole});
    refreshCPP();
}

void TruthTableModel::setOne(const int &row)
{
    if(row < 0 || row >= elements.count()) return;
    elements[row] = "1";
    emit dataChanged(index(row),index(row),{Qt::DisplayRole});
    refreshCPP();
}

void TruthTableModel::setX(const int &row)
{
    if(row < 0 || row >= elements.count()) return;
    elements[row] = "X";
    emit dataChanged(index(row),index(row),{Qt::DisplayRole});
    refreshCPP();
}

void TruthTableModel::setEmpty(const int &row)
{
    if(row < 0 || row >= elements.count()) return;
    elements[row] = " ";
    emit dataChanged(index(row),index(row),{Qt::DisplayRole});
    refreshCPP();
}

void TruthTableModel::allZero()
{
    if (booleanFunction->getNumVariables() == 2)
    {
    } else if (booleanFunction->getNumVariables() == 3)
    {
    } else if (booleanFunction->getNumVariables() == 4)
    {
        for (int i=0; i<16; i++) elements[5*i+4] = "0";
    } else if (booleanFunction->getNumVariables() == 5)
    {
    }
    emit dataChanged(index(0),index(elements.count()-1),{Qt::DisplayRole});
    refreshCPP();
}

void TruthTableModel::allOne()
{
    if (booleanFunction->getNumVariables() == 2)
    {
    } else if (booleanFunction->getNumVariables() == 3)
    {
    } else if (booleanFunction->getNumVariables() == 4)
    {
        for (int i=0; i<16; i++) elements[5*i+4] = "1";
    } else if (booleanFunction->getNumVariables() == 5)
    {
    }
    emit dataChanged(index(0),index(elements.count()-1),{Qt::DisplayRole});
    refreshCPP();
}

void TruthTableModel::allEmpty()
{
    if (booleanFunction->getNumVariables() == 2)
    {
    } else if (booleanFunction->getNumVariables() == 3)
    {
    } else if (booleanFunction->getNumVariables() == 4)
    {
        for (int i=0; i<16; i++) elements[5*i+4] = " ";
    } else if (booleanFunction->getNumVariables() == 5)
    {
    }
    emit dataChanged(index(0),index(elements.count()-1),{Qt::DisplayRole});
    refreshCPP();
}

void TruthTableModel::allRandom()
{
    booleanFunction->makeAllRandom(); // changes are made by C++
    onModelChanged(); // refresh QML elements
    emit modelChanged(); // notifies other classes about the change
}
