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

#ifndef TRUTHTABLEMODEL_H
#define TRUTHTABLEMODEL_H

#include "booleanfunction.h"

#include <QObject>
#include <QAbstractListModel>

class TruthTableModel : public QAbstractListModel
{
    Q_OBJECT

    // elements for TruthTableModel is not the same as elements for KarnaughMapModel
    //
    // This is for TruthTableModel:
    // size(elements) = (numVariables + 1) * numMinterms
    // numVariables == 2: size(elements) = (2+1) * 4 = 12, elements = "00x01x10x11x"
    // numVariables == 3: size(elements) = (3+1) * 8 = 32, elements = "000x001x010x011x100x101x110x111x"
    // numVariables == 4: size(elements) = (4+1) * 16 = 80, elements = "0000x0001x..."
    // numVariables == 5: size(elements) = (5+1) * 32 = 192, elements = "00000x00001x..."

    private:
        BooleanFunction *booleanFunction;
        QList<QString> elements;
        QList<QString> variableNames;

    public:
        explicit TruthTableModel(QObject *parent = nullptr, BooleanFunction *bf = nullptr);
        ~TruthTableModel();
        virtual int rowCount(const QModelIndex&) const;
        virtual QVariant data(const QModelIndex&,int) const;
        void refreshCPP();

        Q_INVOKABLE QString get(const int&);
        Q_INVOKABLE QString getVariableName(const int&); //get ith variable name
        Q_INVOKABLE void setVariableName(const int&, const QString&); //set ith variable name
        Q_INVOKABLE QString string2html(const QString&); //change string for presentation
        Q_INVOKABLE void setZero(const int&); //change one element
        Q_INVOKABLE void setOne(const int&); //change one element
        Q_INVOKABLE void setX(const int&); //change one element
        Q_INVOKABLE void setEmpty(const int&); //change one element
        Q_INVOKABLE void allZero(); //create special Truth table
        Q_INVOKABLE void allOne(); //create special Truth table
        Q_INVOKABLE void allEmpty(); //create special Truth table
        Q_INVOKABLE void allRandom(); //create random Truth table

    signals:
        void modelChanged();

    public slots:
        void onModelChanged(); //this method can be connected to a signal

};

#endif // TRUTHTABLEMODEL_H
