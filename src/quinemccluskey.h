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

#ifndef QUINEMCCLUSKEY_H
#define QUINEMCCLUSKEY_H

#include "booleanfunction.h"

#include <iostream>
#include <fstream>
#include <set>
#include <map>

class QuineMcCluskey
{
    private:
        BooleanFunction *booleanFunction;

    public:
        QuineMcCluskey(BooleanFunction *bf);
        set<Biddy_Edge> createInitSet();
        void debugSet(set<Biddy_Edge>);
        unsigned int numones(Biddy_Edge f);
        bool isImplicant(Biddy_Edge f);
        bool isAdjacent(Biddy_Edge f, Biddy_Edge g);
        bool isRedundant(Biddy_Edge f);
        void addQmlogSet(set<Biddy_Edge>);
        void addQmlogLabelledSet(set<Biddy_Edge>,set<Biddy_Edge>);
        void minimize();
        void updateResults();
};

#endif // QUINEMCCLUSKEY_H
