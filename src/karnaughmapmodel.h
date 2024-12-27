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

#ifndef KARNAUGHMAPMODEL_H
#define KARNAUGHMAPMODEL_H

#include "booleanfunction.h"

#include <QObject>
#include <QAbstractListModel>

class KarnaughMapModel : public QAbstractListModel
{
    Q_OBJECT

    // elements for KarnaughMapModel is not the same as elements for TruthTableModel
    //
    // This is for KarnaughMapModel:
    // size(elements) = numMinterms
    // numVariables == 2: size(elements) = 4, elements = "0000"
    // numVariables == 3: size(elements) = 8, elements = "00000000"
    // numVariables == 4: size(elements) = 16, elements = "0000000000000000"
    // numVariables == 5: size(elements) = 32, elements = "00000000000000000000000000000000"

    private:
        BooleanFunction *booleanFunction;
        QList<QString> elements;

    public:
        explicit KarnaughMapModel(QObject *parent = nullptr, BooleanFunction *bf = nullptr);
        ~KarnaughMapModel();
        virtual int rowCount(const QModelIndex &parent) const;
        virtual QVariant data(const QModelIndex &index, int role) const;
        void refreshCPP();

        Q_INVOKABLE QString get(const int&);
        Q_INVOKABLE void setZero(const int&); //change one element
        Q_INVOKABLE void setOne(const int&); //change one element
        Q_INVOKABLE void setX(const int&); //change one element
        Q_INVOKABLE void setEmpty(const int&); //change one element
        Q_INVOKABLE void allZero(); //create special Karnaugh map
        Q_INVOKABLE void allOne(); //create special Karnaugh map
        Q_INVOKABLE void allEmpty(); //create special Karnaugh map
        Q_INVOKABLE void allRandom(); //create random Karnaugh map

        Q_PROPERTY(QString bits READ getBits)
        QString getBits() const {return QString::fromStdString(booleanFunction->getBits());}

    signals:
        void modelChanged();

    public slots:
        void onModelChanged(); //this method can be connected to a signal

};

#endif // KARNAUGHMAPMODEL_H
