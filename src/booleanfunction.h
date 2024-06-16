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

#ifndef BOOLEANFUNCTION_H
#define BOOLEANFUNCTION_H

#include <string>
#include <array>
#include <random>
#include <set>

#include "biddy/biddy.h"

using namespace std;

// general functions not related to Boolean functions or Biddy package
void ltrim(std::string &);
void rtrim(std::string &);
void trim(std::string &);
void replaceAll(std::string&, const std::string&, const std::string&);

// these functions are using Biddy package directly, i.e. they operate on Biddy_Edge and not on BooleanFunction
// they could be declared static, but it is more elegant to declare them outside the class
void initBdd();
void exitBdd();
string booleanFunction2string(Biddy_Edge);
string implicant2string(Biddy_Edge);
string implicant2symbol(Biddy_Edge, Biddy_Edge);
Biddy_Edge permitsymData(Biddy_Edge, Biddy_Variable, unsigned int);

// minterms are listed top-down first (i.e. first values are first column)
const array<unsigned int,4> KARNAUGH2x2 = {{0,1,2,3}};
const array<unsigned int,8> KARNAUGH3x3 = {{0,4,1,5,3,7,2,6}};
const array<unsigned int,16> KARNAUGH4x4 = {{0,4,12,8,1,5,13,9,3,7,15,11,2,6,14,10}};
const array<unsigned int,4> VEITCH2x2 = {{3,2,1,0}};
const array<unsigned int,8> VEITCH3x3 = {{6,4,7,5,3,1,2,0}};
const array<unsigned int,16> VEITCH4x4 = {{12,14,10,8,13,15,11,9,5,7,3,1,4,6,2,0}};

struct ImplicantCircle
{
    int cx; // signed because -1 is used for the circle extending over the edge
    int cy; // signed because -1 is used for the circle extending over the edge
    unsigned int cw;
    unsigned int ch;
    unsigned int cc; // used to determine circle's color
};

class BooleanFunction
{
    private:
        random_device rndDevice;
        Biddy_Edge support;
        Biddy_Edge bdd;
        Biddy_Edge dontcarebdd;
        string bits;
        array<string,16> minterms;
        vector<set<Biddy_Edge>> sopSolutions;
        unsigned int selectedSopSolution;
        vector<ImplicantCircle> circles;
        string sop;
        string qmlog;
        vector<string> onset;
        vector<Biddy_Edge> onsetBdd;
        vector<string> implicants;
        vector<Biddy_Edge> implicantsBdd;
        vector<unsigned int> coveringTable;

    protected:

    public:
        BooleanFunction();
        ~BooleanFunction();
        static string string2html(string,string);
        void makeAllZero();
        void makeAllOne();
        void makeAllEmpty();
        void makeAllRandom();
        void update();

        // === Biddy_Edge support;
        Biddy_Edge getSupport();

        // === Biddy_Edge bdd;
        Biddy_Edge getBdd();

        // === Biddy_Edge dontcarebdd;
        Biddy_Edge getDontCareBdd();

        // === string bits;
        string getBits();

        // === array<string,16> minterms;
        array<string,16> getMinterms();
        string getMinterm(unsigned int);
        void setMinterm(unsigned int, string);

        // === vector<set<Biddy_Edge>> sopSolutions;
        void addSopSolutions(set<Biddy_Edge>);
        set<Biddy_Edge> getSopSolution(unsigned int);
        void clearSopSolutions();
        unsigned int getNumSopSolutions();
        unsigned int getSelectedSopSolution();
        void setSelectedSopSolution(unsigned int);
        void nextSelectedSopSolution();
        void prevSelectedSopSolution();

        // === vector<ImplicantCircle> circles;
        vector<ImplicantCircle> getCircles();
        ImplicantCircle getCircle(unsigned int);
        void setCircle(unsigned int, ImplicantCircle);
        void addCircle(ImplicantCircle);
        void clearCircles();
        void createCircles(set<Biddy_Edge>);

        // === string sop;
        string getSop();
        void setSop(string);
        void addSopImplicant(string);
        void clearSop();
        void createSop(set<Biddy_Edge>);

        // === string qmlog;
        void setQmlog(string);
        void addQmlogLine(string);
        string getQmlog();

        // === vector<string> onset;
        vector<string> getOnset();
        unsigned int getOnsetSize();
        void addOnset(unsigned int);
        void clearOnset();
        void createOnset(); // DEBUGGING, ONLY
        string reportOnset();

        // === vector<string> implicants;
        vector<string> getImplicants();
        unsigned int getImplicantsSize();
        void addImplicants(Biddy_Edge m);
        void clearImplicants();
        void createImplicants(); // DEBUGGING, ONLY
        string reportImplicants();

        // === vector<unsigned int> coveringTable;
        unsigned int getCoveringTableElement(unsigned int);
        unsigned int getCoveringTableElement(unsigned int, unsigned int);
        void setCoveringTableElement(unsigned int, unsigned int, unsigned int);
        void clearCoveringTable();
        void createCoveringTable(set<Biddy_Edge>);
};

#endif // BOOLEANFUNCTION_H
