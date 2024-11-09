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

#include "booleanfunction.h"
#include "quinemccluskey.h"

#include <algorithm>
#include <cctype>
#include <locale>

// trim is from:
// https://stackoverflow.com/questions/216823/whats-the-best-way-to-trim-stdstring

// trim from start (in place)
void ltrim(std::string &s) {
    s.erase(s.begin(), std::find_if(s.begin(), s.end(), [](int ch) {
        return !std::isspace(ch);
    }));
}

// trim from end (in place)
void rtrim(std::string &s) {
    s.erase(std::find_if(s.rbegin(), s.rend(), [](int ch) {
        return !std::isspace(ch);
    }).base(), s.end());
}

// trim from both ends (in place)
void trim(std::string &s) {
    ltrim(s);
    rtrim(s);
}

// replaceAll is from:
// https://stackoverflow.com/questions/3418231/replace-part-of-a-string-with-another-string

void replaceAll(std::string& str, const std::string& from, const std::string& to) {
    if(from.empty()) return;
    size_t start_pos = 0;
    while((start_pos = str.find(from, start_pos)) != std::string::npos) {
        str.replace(start_pos, from.length(), to);
        start_pos += to.length(); // In case 'to' contains 'from', like replacing 'x' with 'yx'
    }
}

void initBdd()
{
    Biddy_Init();
}

void exitBdd()
{
    Biddy_Exit();
}

string booleanFunction2string(Biddy_Edge f)
{
    char *s;

    s = new char[1]; s[0] = 0; // strdup("")
    Biddy_SprintfSOP(&s,f);
    string t(s);
    rtrim(t);
    return t;
}

string implicant2string(Biddy_Edge f)
{
    string s;
    s = booleanFunction2string(f);
    return s.substr(4);
}

string implicant2symbol(Biddy_Edge sup, Biddy_Edge f)
{
    string s = "";
    while (!Biddy_IsTerminal(sup)) {
        if (Biddy_GetTopVariable(f) == Biddy_GetTopVariable(sup)) {
            if (Biddy_GetThen(f) == Biddy_GetConstantZero()) {
                s += "0";
                f = Biddy_GetElse(f);
            } else if (Biddy_GetElse(f) == Biddy_GetConstantZero()) {
                s += "1";
                f = Biddy_GetThen(f);
            } else {
                //cout << "INTERNAL ERROR!" << endl;
            }
        } else {
            s += "-";
        }
        sup = Biddy_GetThen(sup);
    }
    return s;
}

Biddy_Edge permitsymData(Biddy_Edge f, Biddy_Variable lowest, unsigned int n)
{
    Biddy_Edge e, t, r;
    Biddy_Variable v;
    unsigned int num;

    if (f == Biddy_GetConstantZero()) return f;
    if (lowest == 0) return f;
    v = Biddy_GetTopVariable(f);

    //num = Biddy_GetVariableData(lowest) ? *((unsigned int *)Biddy_GetVariableData(lowest)) : 0;
    //cout << "permitsymData:" << lowest << v << n << num << endl;

    r = nullptr;
    if (v == lowest) {
        if (!Biddy_GetVariableData(lowest)) {
            e = permitsymData(Biddy_InvCond(Biddy_GetElse(f),Biddy_GetMark(f)),Biddy_GetNextVariable(lowest),n);
            t = permitsymData(Biddy_InvCond(Biddy_GetThen(f),Biddy_GetMark(f)),Biddy_GetNextVariable(lowest),n);
        } else {
            e = permitsymData(Biddy_InvCond(Biddy_GetElse(f),Biddy_GetMark(f)),Biddy_GetNextVariable(lowest),n);
            num = *((unsigned int *)Biddy_GetVariableData(lowest));
            if (num > n) {
                t = Biddy_GetConstantZero();
            } else {
                t = permitsymData(Biddy_InvCond(Biddy_GetThen(f),Biddy_GetMark(f)),Biddy_GetNextVariable(lowest),n-num);
            }
        }
    } else {
        if (!Biddy_GetVariableData(lowest)) {
            e = t = permitsymData(f,Biddy_GetNextVariable(lowest),n);
        } else {
            e = permitsymData(f,Biddy_GetNextVariable(lowest),n);
            num = *((unsigned int *)Biddy_GetVariableData(lowest));
            if (num > n) {
                t = Biddy_GetConstantZero();
            } else {
                t = permitsymData(f,Biddy_GetNextVariable(lowest),n-num);
            }
        }
    }

    r = Biddy_TaggedFoaNode(lowest,e,t,lowest,TRUE);
    return r;
}

// ========= class BooleanFunction

// Boolean function is created only once, thes reused everytime, even if num variables changes
BooleanFunction::BooleanFunction()
{
    numVariables = 4;
    if (numVariables == 2) {
        numMinterms = 4;
        support = Biddy_Eval2((Biddy_String)"a*b");
    } else if (numVariables == 3) {
        numMinterms = 8;
        support = Biddy_Eval2((Biddy_String)"a*b*c");
    } else if (numVariables == 4) {
        numMinterms = 16;
        support = Biddy_Eval2((Biddy_String)"a*b*c*d");
    } else if (numVariables == 5) {
        numMinterms = 32;
        support = Biddy_Eval2((Biddy_String)"a*b*c*d*e");
    } else {
        numMinterms = 0;
        support = Biddy_GetConstantZero();
    }
    bdd = nullptr;
    dontcarebdd = nullptr;
    bits = "";
    for (unsigned int i=0; i<MAXMINTERMS; i++) minterms[i] = " ";
    sopSolutions.clear();
    selectedSopSolution = 0;
    circles.clear();
    sop = "";
    qmlog = "";
    onset.clear();
    onsetBdd.clear();
    implicants.clear();
    implicantsBdd.clear();
    coveringTable.clear();
}

BooleanFunction::~BooleanFunction()
{
}

string BooleanFunction::string2html(string s, string variableNames)
{
    string t;
    string a,b,c,d,e;
    //cout << s << endl;
    if (s == "0") return s;
    if (variableNames=="") {
        a = "a";
        b = "b";
        c = "c";
        d = "d";
        e = "e";
    } else {
        a = variableNames[0];
        b = variableNames[1];
        c = variableNames[2];
        d = variableNames[3];
        e = variableNames[4];
    }
    t = s;
    replaceAll(t,"*a","NA");
    replaceAll(t,"*b","NB");
    replaceAll(t,"*c","NC");
    replaceAll(t,"*d","ND");
    replaceAll(t,"*e","NE");
    replaceAll(t,"* a","NA");
    replaceAll(t,"* b","NB");
    replaceAll(t,"* c","NC");
    replaceAll(t,"* d","ND");
    replaceAll(t,"* e","NE");
    replaceAll(t,"a","PA");
    replaceAll(t,"b","PB");
    replaceAll(t,"c","PC");
    replaceAll(t,"d","PD");
    replaceAll(t,"e","PE");
    replaceAll(t,"PA","<span>"+a+"</span>");
    replaceAll(t,"PB","<span>"+b+"</span>");
    replaceAll(t,"PC","<span>"+c+"</span>");
    replaceAll(t,"PD","<span>"+d+"</span>");
    replaceAll(t,"PE","<span>"+e+"</span>");
    replaceAll(t,"NA","<span style=\"text-decoration: overline\">"+a+"</span>");
    replaceAll(t,"NB","<span style=\"text-decoration: overline\">"+b+"</span>");
    replaceAll(t,"NC","<span style=\"text-decoration: overline\">"+c+"</span>");
    replaceAll(t,"ND","<span style=\"text-decoration: overline\">"+d+"</span>");
    replaceAll(t,"NE","<span style=\"text-decoration: overline\">"+e+"</span>");
    if (t.find('+') == std::string::npos) {
      t = "<span></span>" + t;
    } else {
      replaceAll(t,"+","+</div><div><span></span>");
      t = "<div><span></span>" + t + "</div>";
    }
    //cout << t << endl;
    return t;
}

void BooleanFunction::makeAllZero()
{
    for (unsigned int i=0; i<numMinterms; i++) minterms[i] = "0";
    update();
}

void BooleanFunction::makeAllOne()
{
    for (unsigned int i=0; i<numMinterms; i++) minterms[i] = "1";
    update();
}

void BooleanFunction::makeAllEmpty()
{
    for (unsigned int i=0; i<numMinterms; i++) minterms[i] = " ";
    update();
}

void BooleanFunction::makeAllRandom()
{
    default_random_engine rndengine(rndDevice());
    uniform_int_distribution<int> zeroOne(0,1);
    for (unsigned int i=0; i<numMinterms; i++) {
        if (zeroOne(rndengine)) {
            minterms[i] = "0";
        } else {
            if (zeroOne(rndengine)) minterms[i] = "X"; else minterms[i] = "1";
        }
    }
    update();
}

// called after changing minterms
// updates bdd, dontcarebdd, bits
// then calls minimize to update essentialImplicants, sop, onset, implicants, and qmlog
void BooleanFunction::update()
{
    bdd = Biddy_GetConstantZero();
    dontcarebdd = Biddy_GetConstantZero();
    bits = "";
    for (unsigned int i=0; i<numMinterms; i++) {
        if (minterms.at(i) == " ") {
            bits += ".";
        } else if (minterms.at(i) == "0") {
            bits += "0";
        } else if (minterms.at(i) == "X") {
            bits += "X";
            dontcarebdd = Biddy_Or(dontcarebdd,Biddy_CreateMinterm(support,i));
        } else if (minterms.at(i) == "1") {
            bits += "1";
            bdd = Biddy_Or(bdd,Biddy_CreateMinterm(support,i));
        }
    }
    // QuineMcCluskey:minimize() calculates circles and SOP
    QuineMcCluskey qm(this);
    qm.minimize();
    qm.updateResults();
}

// =========
// Biddy_Edge support;

Biddy_Edge BooleanFunction::getSupport()
{
    return support;
}

// =========
// === unsigned int numvariables;
unsigned int BooleanFunction::getNumVariables()
{
    return numVariables;
}

void setNumVariables(unsigned int num)
{
    cout << "setNumVariables: " << num << endl;
}

// =========
// Biddy_Edge bdd;

Biddy_Edge BooleanFunction::getBdd()
{
    return bdd;
}

// =========
// Biddy_Edge dontcarebdd;

Biddy_Edge BooleanFunction::getDontCareBdd()
{
    return dontcarebdd;
}

// =========
// string bits;

string BooleanFunction::getBits()
{
    return bits;
}

// =========
// array<string,MAXMINTERMS> minterms;

array<string,MAXMINTERMS> BooleanFunction::getMinterms()
{
    return minterms;
}

string BooleanFunction::getMinterm(unsigned int i)
{
    return minterms.at(i);
}

void BooleanFunction::setMinterm(unsigned int i, string s)
{
    minterms[i] = s;
}

// =========
// vector<set<Biddy_Edge>> sopSolutions;

void BooleanFunction::addSopSolutions(set<Biddy_Edge> sopSolution)
{
    sopSolutions.push_back(sopSolution);
}

set<Biddy_Edge> BooleanFunction::getSopSolution(unsigned int i)
{
    if (i >= sopSolutions.size()) return std::set<Biddy_Edge>();
    return sopSolutions[i];
}

void BooleanFunction::clearSopSolutions()
{
    sopSolutions.clear();
}

unsigned int BooleanFunction::getNumSopSolutions()
{
    unsigned int n;
    if ((n=sopSolutions.size()) == 0) n = 1;
    return n;
}

unsigned int BooleanFunction::getSelectedSopSolution()
{
    return selectedSopSolution;
}

void BooleanFunction::setSelectedSopSolution(unsigned int n)
{
    if (selectedSopSolution != n) {
        selectedSopSolution = n;
        QuineMcCluskey qm(this);
        qm.updateResults();
    }
}

void BooleanFunction::nextSelectedSopSolution()
{
    if (sopSolutions.size() > 1) {
        selectedSopSolution = (selectedSopSolution + 1) % sopSolutions.size();
        QuineMcCluskey qm(this);
        qm.updateResults();
    }
}

void BooleanFunction::prevSelectedSopSolution()
{
    if (sopSolutions.size() > 1) {
        selectedSopSolution = (selectedSopSolution + sopSolutions.size() - 1) % sopSolutions.size();
        QuineMcCluskey qm(this);
        qm.updateResults();
    }
}

// =========
// vector<ImplicantCircle> circles;

vector<ImplicantCircle> BooleanFunction::getCircles() {
    return circles;
}

ImplicantCircle BooleanFunction::getCircle(unsigned int i)
{
    return circles.at(i);
}

void BooleanFunction::setCircle(unsigned int i, ImplicantCircle kc)
{
    circles[i] = kc;
}

void BooleanFunction::addCircle(ImplicantCircle kc)
{
    //unsigned int cnum = circles.size();
    //kc.cc = cnum;
    circles.push_back(kc);
    if ((kc.cx + kc.cw > 4) && (kc.cy + kc.ch <= 4)) {
        // this circle extends from right edge to the left edge
        ImplicantCircle kc1;
        kc1.cc = kc.cc;
        kc1.cx = -1; kc1.cy = kc.cy; kc1.cw = 2; kc1.ch = kc.ch;
        circles.push_back(kc1);
    }
    if ((kc.cx + kc.cw <= 4) && (kc.cy + kc.ch > 4)) {
        // this circle extends from right edge to the down edge
        ImplicantCircle kc1;
        kc1.cc = kc.cc;
        kc1.cx = kc.cx; kc1.cy = -1; kc1.cw = kc.cw; kc1.ch = 2;
        circles.push_back(kc1);
    }
    if ((kc.cx + kc.cw > 4) && (kc.cy + kc.ch > 4)) {
        // this circle extends from both edges
        ImplicantCircle kc1;
        kc1.cc = kc.cc;
        kc1.cx = -1; kc1.cy = -1; kc1.cw = 2; kc1.ch = 2;
        circles.push_back(kc1);
        kc1.cx = kc.cx; kc1.cy = -1; kc1.cw = 2; kc1.ch = 2;
        circles.push_back(kc1);
        kc1.cx = -1; kc1.cy = kc.cy; kc1.cw = 2; kc1.ch = 2;
        circles.push_back(kc1);
    }
}

void BooleanFunction::clearCircles()
{
    circles.clear();
}

// CREATE CIRCLE FOR EVERY IMPLICANT IN THE ESSENTIAL SET - THIS SHOULD BE COMPATIBLE WITH BooleanFunction::createSop
// booleanFunction->circles IS A VECTOR
void BooleanFunction::createCircles(set<Biddy_Edge> theset)
{
    clearCircles();

    unsigned int idx = 0;
    if (numVariables == 2) {
        for (unsigned int n=0; n<=2; n++)
        {

        }
    } else if (numVariables == 3) {
        for (unsigned int n=0; n<=3; n++)
        {

        }
    } else if (numVariables == 4) {
        for (unsigned int n=0; n<=4; n++)
        {
            for (Biddy_Edge implicant: theset) if (Biddy_DependentVariableNumber(implicant,FALSE) == n) {
                //cout << "CREATE CIRCLES: " << booleanFunction2string(implicant) << endl;
                int i = 0;
                bool OK = false;
                while (!OK && (i<16)) {
                    if (Biddy_And(implicant,Biddy_CreateMinterm(support,KARNAUGH4x4.at(i))) != Biddy_GetConstantZero()) OK = true;
                    else i++;
                }
                if (OK) {
                    unsigned int w = 1;
                    unsigned int h = 1;
                    if ((i%4 != 3) && Biddy_And(implicant,Biddy_CreateMinterm(support,KARNAUGH4x4.at(i+1))) != Biddy_GetConstantZero()) w = 2;
                    if ((i%4 == 0) && (w == 2) && Biddy_And(implicant,Biddy_CreateMinterm(support,KARNAUGH4x4.at(i+3))) != Biddy_GetConstantZero()) w = 4;
                    if ((i%4 == 0) && (w == 1) && Biddy_And(implicant,Biddy_CreateMinterm(support,KARNAUGH4x4.at(i+3))) != Biddy_GetConstantZero()) {i = i + 3; w = 2;}
                    if ((i < 12) && Biddy_And(implicant,Biddy_CreateMinterm(support,KARNAUGH4x4.at(i+4))) != Biddy_GetConstantZero()) h = 2;
                    if ((i < 4) && (h == 2) && Biddy_And(implicant,Biddy_CreateMinterm(support,KARNAUGH4x4.at(i+12))) != Biddy_GetConstantZero()) h = 4;
                    if ((i < 4) && (h == 1) && Biddy_And(implicant,Biddy_CreateMinterm(support,KARNAUGH4x4.at(i+12))) != Biddy_GetConstantZero()) {i = i + 12; h = 2;}
                    addCircle({(int)i%4,(int)i/4,w,h,idx++}); // last argument is color
                }
            }
        }
    } else if (numVariables == 5) {
        for (unsigned int n=0; n<=5; n++)
        {

        }
    }
}

// =========
// string sop;

string BooleanFunction::getSop()
{
    return sop;
}

void BooleanFunction::setSop(string s)
{
    sop = s;
}

void BooleanFunction::addSopImplicant(string implicant)
{
    if (sop != "") sop = sop + " +";
    sop = sop + implicant;

    //cout << "addSopImplicant: " << implicant << " : " << getSop() << endl;
}

void BooleanFunction::clearSop()
{
    sop = "";
}

// CREATE SOP STRING FOR EVERY IMPLICANT IN THE ESSENTIAL SET - THIS SHOULD BE COMPATIBLE WITH BooleanFunction::createCircles
void BooleanFunction::createSop(set<Biddy_Edge> essentialImplicants)
{
    clearSop();

    // circles and implicants should be added to final SOP in an ordered way:
    // 1. regarding the number of dependent variables, those with less variables go first
    // 2. (TO DO) regarding the name of first variables, those with smaller name go first
    // 3. (TO DO) regarding the positivness of first variable, those with positive variable go first
    for (unsigned int n=0; n<=numVariables; n++) {
        for (auto implicant : essentialImplicants) if (Biddy_DependentVariableNumber(implicant,FALSE) == n) {
            //cout << "SET FINAL SOP: " << booleanFunction2string(implicant) << endl;
            addSopImplicant(implicant2string(implicant));
        }
    }
}

// =========
// string qmlog;

void BooleanFunction::setQmlog(string s)
{
    qmlog = s;
}

void BooleanFunction::addQmlogLine(string line)
{
    qmlog = qmlog + "<div>" + line + "</div>";
}

string BooleanFunction::getQmlog()
{
    return qmlog;
}

// =========
// vector<string> onset;

vector<string> BooleanFunction::getOnset()
{
    return onset;
}

unsigned int BooleanFunction::getOnsetSize()
{
    return onset.size();
}

void BooleanFunction::addOnset(unsigned int i)
{
    onset.push_back(to_string(i));
    onsetBdd.push_back(Biddy_CreateMinterm(support,i));
}

void BooleanFunction::clearOnset()
{
    onset.clear();
    onsetBdd.clear();
}

// DEBUGGING, ONLY
void BooleanFunction::createOnset()
{
    return;

    // GUI TESTING, ONLY
    clearOnset();
    addOnset(1);
    addOnset(3);
    addOnset(5);
    addOnset(7);
    addOnset(9);
    addOnset(11);
    addOnset(13);
    addOnset(15);
}

string BooleanFunction::reportOnset()
{
    string result = "";
    for (unsigned int i=0; i<onset.size(); i++) {
        result = result + "(" + onset[i] + ")";
    }
    return result;
}

// =========
// vector<string> implicants;

vector<string> BooleanFunction::getImplicants()
{
    return implicants;
}

unsigned int BooleanFunction::getImplicantsSize()
{
    return implicants.size();
}

void BooleanFunction::addImplicants(Biddy_Edge m)
{
    implicants.push_back(implicant2symbol(getSupport(),m));
    implicantsBdd.push_back(m);
}

void BooleanFunction::clearImplicants()
{
    implicants.clear();
    implicantsBdd.clear();
}

// DEBUGGING, ONLY
void BooleanFunction::createImplicants()
{
    return;

    // GUI TESTING, ONLY
    clearImplicants();
    addImplicants(Biddy_GetConstantOne());
}

string BooleanFunction::reportImplicants()
{
    string result = "";
    for (unsigned int i=0; i<implicants.size(); i++) {
        result = result + "(" + implicants[i] + ")";
    }
    return result;
}

// =========
// vector<unsigned int> coveringTable;

unsigned int BooleanFunction::getCoveringTableElement(unsigned int index)
{
    if (index >= coveringTable.size()) return 0;
    return coveringTable[index];
}

unsigned int BooleanFunction::getCoveringTableElement(unsigned int implicant, unsigned int minterm)
{
    unsigned int index = (implicant * implicants.size()) + minterm;
    if (index >= coveringTable.size()) return 0;
    return coveringTable[index];
}

void BooleanFunction::setCoveringTableElement(unsigned int implicant, unsigned int minterm, unsigned int value)
{
    unsigned int size = coveringTable.size();
    unsigned int index = implicant * onset.size() + minterm;
    for (unsigned int i = size; i <= index; i++) coveringTable.push_back(0);
    coveringTable[index] = value;
}

void BooleanFunction::clearCoveringTable()
{
    coveringTable.clear();
}

void BooleanFunction::createCoveringTable(set<Biddy_Edge> essentialImplicants)
{
    clearCoveringTable();

    // DEBUGGING
    /*
    for (unsigned int i=0; i<onsetBdd.size(); i++) {
        cout << "createCoveringTable: minterm " << onset[i] << endl;
    }
    for (unsigned int i=0; i<implicantsBdd.size(); i++) {
        cout << "createCoveringTable: implicant " << implicants[i] << endl;
    }
    */

    string debug = ""; // DEBUGGING
    for (unsigned int i=0; i<implicants.size(); i++) {
        for (unsigned int j=0; j<onset.size(); j++) {
            unsigned int value = 0;
            //value = (i*onset.size()+j)%3; // DEBUGGING
            if (essentialImplicants.find(implicantsBdd[i]) == essentialImplicants.end()) {
                if (Biddy_And(implicantsBdd[i],onsetBdd[j]) == Biddy_GetConstantZero()) value = 0; else value = 2;
            } else {
                if (Biddy_And(implicantsBdd[i],onsetBdd[j]) == Biddy_GetConstantZero()) value = 3; else value = 1;
            }
            setCoveringTableElement(i,j,value);
            debug = debug + to_string(value); // DEBUGGING
        }
    }

    //if (debug != "") cout << "createCoveringTable: " << debug << endl;
}
