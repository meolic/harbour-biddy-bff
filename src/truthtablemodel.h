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

    private:
        BooleanFunction *booleanFunction;
        QList<QString> elements;
        QList<QString> variableNames;

    public:
        explicit TruthTableModel(QObject *parent = nullptr, BooleanFunction *bf = nullptr);
        ~TruthTableModel();
        virtual int rowCount(const QModelIndex &parent) const;
        virtual QVariant data(const QModelIndex &index, int role) const;
        void refreshCPP();

        Q_INVOKABLE QString get(const int &index);
        Q_INVOKABLE QString getVariableName(const int&); //get ith variable name
        Q_INVOKABLE void setVariableName(const int&, const QString&); //set ith variable name
        Q_INVOKABLE QString string2html(const QString&); //change string for presentation
        Q_INVOKABLE void setZero(const int &index); //change one element
        Q_INVOKABLE void setOne(const int &index); //change one element
        Q_INVOKABLE void setX(const int &index); //change one element
        Q_INVOKABLE void setEmpty(const int &index); //change one element
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
