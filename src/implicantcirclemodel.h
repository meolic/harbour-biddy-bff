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

#ifndef IMPLICANTCIRCLEMODEL_H
#define IMPLICANTCIRCLEMODEL_H

#include "booleanfunction.h"

#include <QObject>
#include <QAbstractListModel>

class ImplicantCircleModel : public QAbstractListModel
{
    Q_OBJECT

    private:
        BooleanFunction *booleanFunction;
        QList<ImplicantCircle> elements;

    public:

        enum ImplicantCircleRoles {
            CxRole = Qt::UserRole + 1,
            CyRole = Qt::UserRole + 2,
            CwRole = Qt::UserRole + 3,
            ChRole = Qt::UserRole + 4,
            CcRole = Qt::UserRole + 5
        };

        explicit ImplicantCircleModel(QObject *parent = nullptr, BooleanFunction *bf = nullptr);
        ~ImplicantCircleModel();
        QHash<int, QByteArray> roleNames() const;
        virtual int rowCount(const QModelIndex &parent) const;
        virtual QVariant data(const QModelIndex &index, int role) const;

        Q_INVOKABLE int getCX(const int &index);
        Q_INVOKABLE int getCY(const int &index);
        Q_INVOKABLE int getCW(const int &index);
        Q_INVOKABLE int getCH(const int &index);
        Q_INVOKABLE int getCC(const int &index);

    signals:
        void modelChanged();

    public slots:
        void onModelChanged(); //this method can be connected to a signal

};

#endif // IMPLICANTCIRCLEMODEL_H
