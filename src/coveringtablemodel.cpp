// Copyright (C) 2024,2025 Robert Meolic, SI-2000 Maribor, Slovenia.

// biddy-bff is free software; you can redistribute it and/or modify it under the terms
// of the GNU General Public License as published by the Free Software Foundation;
// either version 2 of the License, or (at your option) any later version.

// biddy-bff is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
// PARTICULAR PURPOSE. See the GNU General Public License for more details.

// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51 Franklin
// Street, Fifth Floor, Boston, MA 02110-1301 USA.

#include "coveringtablemodel.h"

#include<QDebug>
#define QT_NO_DEBUG_OUTPUT

// there exists multiple instances of CoveringTableModel, one for each size of Boolean function

CoveringTableModel::CoveringTableModel(QObject *parent, BooleanFunction *bf) : QAbstractListModel(parent)
{
    //qDebug() << "CoveringTableModel INIT";

    booleanFunction = bf;
    elements.clear();
    elementsOnset.clear();
    elementsImplicants.clear();
}

CoveringTableModel::~CoveringTableModel()
{
}

QHash<int, QByteArray> CoveringTableModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[CoveringRole] = "covering";
    roles[OnsetRole] = "minterm";
    roles[ImplicantsRole] = "implicant";
    return roles;
}

// requred by QAbstractListModel
int CoveringTableModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    int num = elements.count();
    if (num) num++; //vertical legend has one extra element
    return num;
}

// requred by QAbstractListModel
QVariant CoveringTableModel::data(const QModelIndex &index, int role) const
{
    //qDebug() << "CoveringTableModel::data index.row()=" << index.row();
    //qDebug() << "CoveringTableModel::data index.column()=" << index.column();

    // the index returns the requested row and column information.
    // we ignore the column and only use the row information
    int row = index.row();

    // boundary check for the row
    if ((role == CoveringRole) && (row < 0 || row >= elements.count())) {
        return QVariant();
    }
    if ((role == OnsetRole) && (row < 0 || row > elementsOnset.count())) {
        return QVariant();
    }
    if ((role == ImplicantsRole) && (row < 0 || row >= elementsImplicants.count())) {
        return QVariant();
    }

    // A model can return data for different roles.
    // The default role is the display role.
    // it can be accesses in QML with "model.display"
    switch(role) {
        case CoveringRole: {
            //qDebug() << "CoveringTableModel::data (CoveringRole) row=" << row << ", elements.value(row)=" << elements.value(row);
            return elements.value(row); // Qt automatically converts returned values to the QVariant type
        }
        case OnsetRole: {
            //qDebug() << "CoveringTableModel::data (OnsetRole) row=" << row << ", elementsOnset.value(row)=" << (row ? elementsOnset.value(row-1) : "minterms");
            if (row) {
                return elementsOnset.value(row-1); // Qt automatically converts returned values to the QVariant type
            } else {
                return QString("minterms "); // Qt automatically converts returned values to the QVariant type
            }
        }
        case ImplicantsRole: {
            //qDebug() << "CoveringTableModel::data (ImplicantsRole) row=" << row << ", elementsImplicants.value(row)=" << elementsImplicants.value(row);
            return elementsImplicants.value(row); // Qt automatically converts returned values to the QVariant type
        }
    }

    // Asked for other data, just return an empty QVariant
    return QVariant();
}

// onModelChanged() is used to refresh QM.qml to reflect the changed model
void CoveringTableModel::onModelChanged()
{
    //qDebug() << "CoveringTableModel::onModelChanged()";

    //REMOVE ALL ELEMENTS AND CREATE NEW ONES
    beginResetModel();
    elements.clear();
    elementsOnset.clear();
    elementsImplicants.clear();
    const unsigned int loopOnsetSize = booleanFunction->getOnsetSize();
    const vector<string> onset = booleanFunction->getOnset();
    for (unsigned int i=0; i<loopOnsetSize; i++) {
        //elementsOnset << QString::fromStdString(to_string(i)); // GUI DEBUGGING
        elementsOnset << QString::fromStdString(onset[i]);
    }
    const unsigned int loopImplicantsSize = booleanFunction->getImplicantsSize();
    const vector<string> implicants = booleanFunction->getImplicants();
    for (unsigned int i=0; i<loopImplicantsSize; i++) {
        //elementsImplicants << QString::fromStdString(to_string(i)); // GUI DEBUGGING
        elementsImplicants << QString::fromStdString(implicants[i]);
    }
    const unsigned int loopSize = booleanFunction->getImplicantsSize() * booleanFunction->getOnsetSize();
    for (unsigned int i=0; i<loopSize; i++) {
        //elements << QString::fromStdString(to_string(i%3)); // GUI DEBUGGING
        elements << QString::fromStdString(to_string(booleanFunction->getCoveringTableElement(i)));
    }
    endResetModel();

    // algorithm is like this:
    // 1. user clicks on diagram or truth table, then karnaughMapModel or truthTableModel emits modelChanged()
    // 2. signal modelChanged() starts this function and it emits sopChanged()
    // 3. signal sopChanged() is used in GUI to start updating all the elements showing SOP
    //    (this action does not target the Karnaugh diagram and the truth table itself)
    emit sopChanged();

    //qDebug() << "getOnsetSize: " << booleanFunction->getOnsetSize();
    //qDebug() << "getCoveringSize: " << booleanFunction->getCoveringSize();

    // DEBUGGING
    //for (unsigned int i=0; i<booleanFunction->getOnsetSize() * booleanFunction->getCoveringSize(); i++) qDebug() << elements[i];
}

void CoveringTableModel::nextSelectedSopSolution()
{
    // qDebug() << "CoveringTableModel::nextSelectedSopSolution() is started";
    booleanFunction->nextSelectedSopSolution();
    // qDebug() << "CoveringTableModel is goint to emit modelChanged()";
    emit modelChanged(); // notifies other classes about the change
    // qDebug() << "CoveringTableModel finished modelChanged()";
    // qDebug() << "CoveringTableModel is goint to start onModelChanged()";
    onModelChanged(); // you have to update also GUI elements controlled by this class
    // qDebug() << "CoveringTableModel finished onModelChanged()";
}

void CoveringTableModel::prevSelectedSopSolution()
{
    booleanFunction->prevSelectedSopSolution();
    emit modelChanged(); // notifies other classes about the change
    onModelChanged(); // you have to update also GUI elements controlled by this class
}
