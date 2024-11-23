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

#include "implicantcirclemodel.h"

#include<QDebug>
#define QT_NO_DEBUG_OUTPUT

// there exists multiple instances of ImplicantCircleModel, one for each size of Boolean function

ImplicantCircleModel::ImplicantCircleModel(QObject *parent, BooleanFunction *bf) : QAbstractListModel(parent)
{
    //qDebug() << "ImplicantCircleModel INIT";

    booleanFunction = bf;
    for (ImplicantCircle kc: booleanFunction->getCircles()) {
        elements.append(kc);
    }
}

ImplicantCircleModel::~ImplicantCircleModel()
{
}

QHash<int, QByteArray> ImplicantCircleModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[CxRole] = "cx";
    roles[CyRole] = "cy";
    roles[CwRole] = "cw";
    roles[ChRole] = "ch";
    roles[CcRole] = "cc";
    return roles;
}

// requred by QAbstractListModel
int ImplicantCircleModel::rowCount(const QModelIndex &parent) const
{
    //qDebug() << "ImplicantCircleModel::rowCount";

    Q_UNUSED(parent);
    return elements.count();
}

// requred by QAbstractListModel
QVariant ImplicantCircleModel::data(const QModelIndex &index, int role) const
{
    //qDebug() << "ImplicantCircleModel::data";

    // the index returns the requested row and column information.
    // we ignore the column and only use the row information
    int row = index.row();

    // boundary check for the row
    if(row < 0 || row >= elements.count()) {
        return QVariant();
    }

    // A model can return data for different roles.
    // The default role is the display role, it can be accesses in QML with "model.display"
    switch(role) {
        case CxRole: {
            //qDebug() << "CxRole row=" << row;
            // Qt automatically converts simple types to the QVariant type
            return elements.value(row).cx;
        }
        case CyRole: {
            //qDebug() << "CyRole row=" << row;
            // Qt automatically converts simple types to the QVariant type
            return elements.value(row).cy;
        }
        case CwRole: {
            //qDebug() << "CxRole row=" << row;
            // Qt automatically converts simple types to the QVariant type
            return elements.value(row).cw;
        }
        case ChRole: {
            //qDebug() << "CxRole row=" << row;
            // Qt automatically converts simple types to the QVariant type
            return elements.value(row).ch;
        }
        case CcRole: {
            //qDebug() << "CcRole row=" << row;
            // Qt automatically converts simple types to the QVariant type
            return elements.value(row).cc;
        }
    }

    // Asked for other data, just return an empty QVariant
    return QVariant();
}

// onModelChanged() is used to refresh QML structures to reflect the changed model
void ImplicantCircleModel::onModelChanged()
{
    //qDebug() << "ImplicantCircleModel::onModelChanged()";

    //REMOVE ALL CIRCLES AND CREATE NEW ONES
    beginResetModel();
    elements.clear();
    for (ImplicantCircle kc: booleanFunction->getCircles()) {
        elements.append(kc);
    }
    endResetModel();
}

int ImplicantCircleModel::getCX(const int &row)
{
    if(row < 0 || row >= elements.count()) {
        return 0;
    }
    return elements.at(row).cx;
}

int ImplicantCircleModel::getCY(const int &row)
{
    if(row < 0 || row >= elements.count()) {
        return 0;
    }
    return elements.at(row).cy;
}

int ImplicantCircleModel::getCW(const int &row)
{
    if(row < 0 || row >= elements.count()) {
        return 0;
    }
    return elements.at(row).cw;
}

int ImplicantCircleModel::getCH(const int &row)
{
    if(row < 0 || row >= elements.count()) {
        return 0;
    }
    return elements.at(row).ch;
}

int ImplicantCircleModel::getCC(const int &row)
{
    if(row < 0 || row >= elements.count()) {
        return 0;
    }
    return elements.at(row).cc;
}
