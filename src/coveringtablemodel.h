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

#ifndef COVERINGTABLEMODEL_H
#define COVERINGTABLEMODEL_H

#include "booleanfunction.h"

#include <QObject>
#include <QAbstractListModel>

class CoveringTableModel : public QAbstractListModel
{
    Q_OBJECT

    private:
        BooleanFunction *booleanFunction;
        QList<QString> elements;
        QList<QString> elementsOnset;
        QList<QString> elementsImplicants;

    public:

        enum CoveringTableRoles {
            CoveringRole = Qt::UserRole + 1,
            OnsetRole = Qt::UserRole + 3,
            ImplicantsRole = Qt::UserRole + 2,
        };

        explicit CoveringTableModel(QObject *parent = nullptr, BooleanFunction *bf = nullptr);
        ~CoveringTableModel();
        QHash<int, QByteArray> roleNames() const;
        virtual int rowCount(const QModelIndex &parent) const;
        virtual QVariant data(const QModelIndex &index, int role) const;

        Q_INVOKABLE void nextSelectedSopSolution();; // change solution, show the next one
        Q_INVOKABLE void prevSelectedSopSolution();; // change solution, show the previous one

        Q_PROPERTY(QString sop READ getSop NOTIFY sopChanged)
        QString getSop() const {return QString::fromStdString(booleanFunction->getSop());}

        Q_PROPERTY(QString numSopSolutions READ getNumSopSolutions NOTIFY sopChanged)
        QString getNumSopSolutions() const {return QString::fromStdString(to_string(booleanFunction->getNumSopSolutions()));}

        Q_PROPERTY(QString selectedSopSolution READ getSelectedSopSolution NOTIFY sopChanged)
        QString getSelectedSopSolution() const {return QString::fromStdString(to_string(1+booleanFunction->getSelectedSopSolution()));}

        Q_PROPERTY(QString qmlog READ getQmlog NOTIFY sopChanged)
        QString getQmlog() const {return QString::fromStdString(booleanFunction->getQmlog());}

        Q_PROPERTY(unsigned int onsetSize READ getOnsetSize NOTIFY sopChanged)
        unsigned int getOnsetSize() const {return booleanFunction->getOnsetSize();}

        Q_PROPERTY(unsigned int implicantsSize READ getImplicantsSize NOTIFY sopChanged)
        unsigned int getImplicantsSize() const {return booleanFunction->getImplicantsSize();}

    signals:
        void modelChanged();
        void sopChanged();

    public slots:
        void onModelChanged(); //this method can be connected to a signal

};

#endif // COVERINGTABLEMODEL_H
