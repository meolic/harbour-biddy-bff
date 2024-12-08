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

#include "quinemccluskey.h"

// Constructor
QuineMcCluskey::QuineMcCluskey(BooleanFunction *bf)
{
    booleanFunction = bf;

    //cout << "QuineMcCluskey::QuineMcCluskey()" << endl;
    //cout << "f:" << booleanFunction2string(booleanFunction->getBdd()) << endl;
    //cout << "x:" << booleanFunction2string(booleanFunction->getDontCareBdd()) << endl;
}

// Write out elements of the set of Boolean functions
void QuineMcCluskey::debugSet(set<Biddy_Edge> theset)
{
    cout << "DEBUG SET" << endl;
    for (auto m: theset) {
         cout << implicant2string(m)
             << (isImplicant(m) ? "IMPLICANT" : "NOT IMPLICANT")
             << "/ numones:" << numones(m) << endl;
    }
}

void QuineMcCluskey::addQmlogSet(set<Biddy_Edge> theset)
{
    // cout << "ADD QMLLOG SET" << endl;

    // PLAIN ORDERING
    /*
    for (auto m: theset) {
        //cout << "ELEMENT: " << implicant2string(m) << endl;
        //cout << implicant2symbol(booleanFunction->getSupport(),m) << endl;
        booleanFunction->addQmlogLine(implicant2symbol(booleanFunction->getSupport(),m));
    }
    */

    // ORDERED BY NUMBER OF MINTERMS

    int v = booleanFunction->getNumVariables();
    for (unsigned int n=1; n<=booleanFunction->getNumMinterms(); n=n*2) {
        for (auto m: theset) if (Biddy_CountMinterms(m,v) == n) {
            cout << "QuineMcCluskey::addQmlogSet ELEMENT: " << implicant2string(m) << endl;
            cout << implicant2symbol(booleanFunction->getSupport(),m) << endl;
            booleanFunction->addQmlogLine(implicant2symbol(booleanFunction->getSupport(),m));
        }
    }
}

// Write out elements of the set of Boolean functions, add label if element is present in the second set
void QuineMcCluskey::addQmlogLabelledSet(set<Biddy_Edge> theset, set<Biddy_Edge> thelabels)
{
    //cout << "ADD QMLLOG LABELLED SET" << endl;
    for (auto m: theset) {
        //cout << "ELEMENT: " << implicant2string(m) << endl;
        //cout << implicant2symbol(booleanFunction->getSupport(),m) << endl;
        //HTML Character Sets (https://www.w3schools.com/charsets/)
        //INTERESTING SYMBOLS: &#10003; &#10004;
        string label;
        if (thelabels.empty() || (thelabels.find(m) == thelabels.end())) {label = "";} else {label = " &#10003;";}
        booleanFunction->addQmlogLine(implicant2symbol(booleanFunction->getSupport(),m)+label);
    }
}

// Create set of implicants which includes all and only minterms
set<Biddy_Edge> QuineMcCluskey::createInitSet()
{
    set<Biddy_Edge> set1X;

    Biddy_Edge f = booleanFunction->getBdd();
    Biddy_Edge x = booleanFunction->getDontCareBdd();

    //cout << "QuineMcCluskey::createInitSet()" << endl;
    //cout << booleanFunction2string(f) << endl;

    // 1's
    while (f != Biddy_GetConstantZero()) {
        Biddy_Edge m = Biddy_ExtractMintermWithSupport(booleanFunction->getSupport(),f);
        set1X.insert(m);
        f = Biddy_Gt(f,m); // gt(f,g) = and(f,not(g))
    }

    // X's
    while (x != Biddy_GetConstantZero()) {
        Biddy_Edge m = Biddy_ExtractMintermWithSupport(booleanFunction->getSupport(),x);
        set1X.insert(m);
        x = Biddy_Gt(x,m); // gt(f,g) = and(f,not(g))
    }

    return set1X;
}

// Check if the given BDD represent an implicant
bool QuineMcCluskey::isImplicant(Biddy_Edge f)
{
    Biddy_Edge g,h;

    // we have to check that there is exactly one 1-path
    // direct implementation is faster than function Biddy_CountPaths()

    if (f == Biddy_GetConstantZero()) return false;
    if (f == Biddy_GetConstantOne()) return true;

    g = Biddy_InvCond(Biddy_GetElse(f),Biddy_GetMark(f));
    h = Biddy_InvCond(Biddy_GetThen(f),Biddy_GetMark(f));

    if (g == Biddy_GetConstantZero()) {
        return isImplicant(h);
    } else {
        if (h == Biddy_GetConstantZero()) {
            return isImplicant(g);
        } else {
            return false;
        }
    }

    return false;
}

// Count number of ones in the given implicant
// Returns 0 if the given BDD is not an implicant
unsigned int QuineMcCluskey::numones(Biddy_Edge f)
{
    Biddy_Edge g,h;

    // we count the number of non-zero 'then' accessors

    if (f == Biddy_GetConstantZero()) return 0;
    if (f == Biddy_GetConstantOne()) return 0;

    g = Biddy_InvCond(Biddy_GetElse(f),Biddy_GetMark(f));
    h = Biddy_InvCond(Biddy_GetThen(f),Biddy_GetMark(f));

    if (g == Biddy_GetConstantZero()) {
        return 1 + numones(h);
    } else {
        if (h == Biddy_GetConstantZero()) {
            return numones(g);
        } else {
            return 0;
        }
    }

    return 0;
}

// Check if the given two implicants are adjacent
// Returns false if any of the given BDDs is not an implicant
bool QuineMcCluskey::isAdjacent(Biddy_Edge f, Biddy_Edge g)
{
    // two implicants are adjacent iff their disjunction is an implicant

    if (!isImplicant(f)) return false;
    if (!isImplicant(g)) return false;

    return isImplicant(Biddy_Or(f,g));
}

// Check if the given implicants is redundant - it does not include any non don't care minterms
bool QuineMcCluskey::isRedundant(Biddy_Edge f)
{
    return (Biddy_And(f,booleanFunction->getBdd()) == Biddy_GetConstantZero());
}

// Quine-McCluskey algorithm
void QuineMcCluskey::minimize()
{
    cout << "QuineMcCluskey::minimize() started" << endl;
    cout << booleanFunction2string(booleanFunction->getBdd()) << endl;

    booleanFunction->setQmlog("");

    if (booleanFunction->getBdd() == Biddy_GetConstantZero()) {
        booleanFunction->clearSopSolutions();
        set<Biddy_Edge> essentialImplicants = set<Biddy_Edge>();
        essentialImplicants.insert(Biddy_GetConstantZero());
        booleanFunction->addSopSolutions(essentialImplicants);
        booleanFunction->setSelectedSopSolution(0);
        booleanFunction->clearOnset();
        booleanFunction->clearImplicants();
        booleanFunction->addQmlogLine("Final set:");
        booleanFunction->addQmlogLine("0");
        //cout << "onset:" << booleanFunction->reportOnset() << endl;
        //cout << "implicants:" << booleanFunction->reportImplicants() << endl;
        //cout << "QuineMcCluskey::minimize() finished with constant zero" << endl;
        return;
    }

    // create complete onset, this is directly used only to show the covering table, not in the algorithm

    booleanFunction->clearOnset();
    for (unsigned int i=0; i<booleanFunction->getNumMinterms(); i++) {
        string m = booleanFunction->getMinterm(i);
        if (m == "1") {
            booleanFunction->addOnset(i);
        }
    }

    // TESTING, ONLY
    if (booleanFunction->getNumVariables() == 2) return;
    if (booleanFunction->getNumVariables() == 3) return;
    //if (booleanFunction->getNumVariables() == 4) return;
    if (booleanFunction->getNumVariables() == 5) return;

    //cout << "QuineMcCluskey::minimize() create init set" << endl;

    // HERE COMES THE QUINE-MCCLUSKEY ALGORITHM
    set<Biddy_Edge> setInit = createInitSet();
    set<Biddy_Edge> setFinal;

    //debugSet(setInit);

    // STEP 1: finding prime implicants // TO DO, extent to 5 variables

    set<Biddy_Edge> setG0,setG1,setG2,setG3,setG4;
    set<Biddy_Edge> setG01,setG12,setG23,setG34;
    set<Biddy_Edge> setG012,setG123,setG234;
    set<Biddy_Edge> setG0123,setG1234;
    set<Biddy_Edge> setG01234;

    set<Biddy_Edge> setG0labels,setG1labels,setG2labels,setG3labels,setG4labels;
    set<Biddy_Edge> setG01labels,setG12labels,setG23labels,setG34labels;
    set<Biddy_Edge> setG012labels,setG123labels,setG234labels;
    set<Biddy_Edge> setG0123labels,setG1234labels;
    set<Biddy_Edge> setG01234labels;

    // STEP 1a: group based on the number of 1s present in their binary equivalents
    for (auto elem : setInit) {
        switch (numones(elem)) {
            case 0:
              setG0.insert(elem);
              break;
            case 1:
              setG1.insert(elem);
              break;
            case 2:
              setG2.insert(elem);
              break;
            case 3:
              setG3.insert(elem);
              break;
            case 4:
              setG4.insert(elem);
        }
    }

    // STEP 1b: concatenate groups

    for (auto elem1 : setG0) {
        for (auto elem2 : setG1) {
            if (isAdjacent(elem1,elem2)) {
                setG0labels.insert(elem1);
                setG1labels.insert(elem2);
                setG01.insert(Biddy_Or(elem1,elem2));
            }
        }
    }

    for (auto elem1 : setG1) {
        for (auto elem2 : setG2) {
            if (isAdjacent(elem1,elem2)) {
                setG1labels.insert(elem1);
                setG2labels.insert(elem2);
                setG12.insert(Biddy_Or(elem1,elem2));
            }
        }
    }

    for (auto elem1 : setG2) {
        for (auto elem2 : setG3) {
            if (isAdjacent(elem1,elem2)) {
                setG2labels.insert(elem1);
                setG3labels.insert(elem2);
                setG23.insert(Biddy_Or(elem1,elem2));
            }
        }
    }

    for (auto elem1 : setG3) {
        for (auto elem2 : setG4) {
            if (isAdjacent(elem1,elem2)) {
                setG3labels.insert(elem1);
                setG4labels.insert(elem2);
                setG34.insert(Biddy_Or(elem1,elem2));
            }
        }
    }

    for (auto elem1 : setG01) {
        for (auto elem2 : setG12) {
            if (isAdjacent(elem1,elem2)) {
                setG01labels.insert(elem1);
                setG12labels.insert(elem2);
                setG012.insert(Biddy_Or(elem1,elem2));
            }
        }
    }

    for (auto elem1 : setG12) {
        for (auto elem2 : setG23) {
            if (isAdjacent(elem1,elem2)) {
                setG12labels.insert(elem1);
                setG23labels.insert(elem2);
                setG123.insert(Biddy_Or(elem1,elem2));
            }
        }
    }

    for (auto elem1 : setG23) {
        for (auto elem2 : setG34) {
            if (isAdjacent(elem1,elem2)) {
                setG23labels.insert(elem1);
                setG34labels.insert(elem2);
                setG234.insert(Biddy_Or(elem1,elem2));
            }
        }
    }

    for (auto elem1 : setG012) {
        for (auto elem2 : setG123) {
            if (isAdjacent(elem1,elem2)) {
                setG012labels.insert(elem1);
                setG123labels.insert(elem2);
                setG0123.insert(Biddy_Or(elem1,elem2));
            }
        }
    }

    for (auto elem1 : setG123) {
        for (auto elem2 : setG234) {
            if (isAdjacent(elem1,elem2)) {
                setG123labels.insert(elem1);
                setG234labels.insert(elem2);
                setG1234.insert(Biddy_Or(elem1,elem2));
            }
        }
    }

    for (auto elem1 : setG0123) {
        for (auto elem2 : setG1234) {
            if (isAdjacent(elem1,elem2)) {
                setG0123labels.insert(elem1);
                setG1234labels.insert(elem2);
                setG01234.insert(Biddy_Or(elem1,elem2));
            }
        }
    }

    // add labels to all implicants that seems to be candidates for prime implicants...
    // ... but they are not prime implicants because they include only don't care minterms
    for (auto m : setG0) if ((setG0labels.empty() || (setG0labels.find(m) == setG0labels.end())) && isRedundant(m)) setG0labels.insert(m);
    for (auto m : setG1) if ((setG1labels.empty() || (setG1labels.find(m) == setG1labels.end())) && isRedundant(m)) setG1labels.insert(m);
    for (auto m : setG2) if ((setG2labels.empty() || (setG2labels.find(m) == setG2labels.end())) && isRedundant(m)) setG2labels.insert(m);
    for (auto m : setG3) if ((setG3labels.empty() || (setG3labels.find(m) == setG3labels.end())) && isRedundant(m)) setG3labels.insert(m);
    for (auto m : setG4) if ((setG4labels.empty() || (setG4labels.find(m) == setG4labels.end())) && isRedundant(m)) setG4labels.insert(m);
    for (auto m : setG01) if ((setG01labels.empty() || (setG01labels.find(m) == setG01labels.end())) && isRedundant(m)) setG01labels.insert(m);
    for (auto m : setG12) if ((setG12labels.empty() || (setG12labels.find(m) == setG12labels.end())) && isRedundant(m)) setG12labels.insert(m);
    for (auto m : setG23) if ((setG23labels.empty() || (setG23labels.find(m) == setG23labels.end())) && isRedundant(m)) setG23labels.insert(m);
    for (auto m : setG34) if ((setG34labels.empty() || (setG34labels.find(m) == setG34labels.end())) && isRedundant(m)) setG34labels.insert(m);
    for (auto m : setG012) if ((setG012labels.empty() || (setG012labels.find(m) == setG012labels.end())) && isRedundant(m)) setG012labels.insert(m);
    for (auto m : setG123) if ((setG123labels.empty() || (setG123labels.find(m) == setG123labels.end())) && isRedundant(m)) setG123labels.insert(m);
    for (auto m : setG234) if ((setG234labels.empty() || (setG234labels.find(m) == setG234labels.end())) && isRedundant(m)) setG234labels.insert(m);
    for (auto m : setG0123) if ((setG0123labels.empty() || (setG0123labels.find(m) == setG0123labels.end())) && isRedundant(m)) setG0123labels.insert(m);
    for (auto m : setG1234) if ((setG1234labels.empty() || (setG1234labels.find(m) == setG1234labels.end())) && isRedundant(m)) setG1234labels.insert(m);
    for (auto m : setG01234) if ((setG01234labels.empty() || (setG01234labels.find(m) == setG01234labels.end())) && isRedundant(m)) setG01234labels.insert(m);

    // collect all prime implicants
    for (auto m : setG0) if (setG0labels.empty() || (setG0labels.find(m) == setG0labels.end())) setFinal.insert(m);
    for (auto m : setG1) if (setG1labels.empty() || setG1labels.find(m) == setG1labels.end()) setFinal.insert(m);
    for (auto m : setG2) if (setG2labels.empty() || setG2labels.find(m) == setG2labels.end()) setFinal.insert(m);
    for (auto m : setG3) if (setG3labels.empty() || setG3labels.find(m) == setG3labels.end()) setFinal.insert(m);
    for (auto m : setG4) if (setG4labels.empty() || setG4labels.find(m) == setG4labels.end()) setFinal.insert(m);
    for (auto m : setG01) if (setG01labels.empty() || setG01labels.find(m) == setG01labels.end()) setFinal.insert(m);
    for (auto m : setG12) if (setG12labels.empty() || setG12labels.find(m) == setG12labels.end()) setFinal.insert(m);
    for (auto m : setG23) if (setG23labels.empty() || setG23labels.find(m) == setG23labels.end()) setFinal.insert(m);
    for (auto m : setG34) if (setG34labels.empty() || setG34labels.find(m) == setG34labels.end()) setFinal.insert(m);
    for (auto m : setG012) if (setG012labels.empty() || setG012labels.find(m) == setG012labels.end()) setFinal.insert(m);
    for (auto m : setG123) if (setG123labels.empty() || setG123labels.find(m) == setG123labels.end()) setFinal.insert(m);
    for (auto m : setG234) if (setG234labels.empty() || setG234labels.find(m) == setG234labels.end()) setFinal.insert(m);
    for (auto m : setG0123) if (setG0123labels.empty() || setG0123labels.find(m) == setG0123labels.end()) setFinal.insert(m);
    for (auto m : setG1234) if (setG1234labels.empty() || setG1234labels.find(m) == setG1234labels.end()) setFinal.insert(m);
    for (auto m : setG01234) if (setG01234labels.empty() || setG01234labels.find(m) == setG01234labels.end()) setFinal.insert(m);

    // STEP 1c: write results to log

    booleanFunction->addQmlogLine("Set of cubes:");
    if (!setG0.empty()) addQmlogLabelledSet(setG0,setG0labels);
    if (!setG1.empty()) addQmlogLabelledSet(setG1,setG1labels);
    if (!setG2.empty()) addQmlogLabelledSet(setG2,setG2labels);
    if (!setG3.empty()) addQmlogLabelledSet(setG3,setG3labels);
    if (!setG4.empty()) addQmlogLabelledSet(setG4,setG4labels);

    if (!setG01.empty() || !setG12.empty() || !setG23.empty() || !setG34.empty()) {
        booleanFunction->addQmlogLine("Set of size 2 implicants:");
        if (!setG01.empty()) addQmlogLabelledSet(setG01,setG01labels);
        if (!setG12.empty()) addQmlogLabelledSet(setG12,setG12labels);
        if (!setG23.empty()) addQmlogLabelledSet(setG23,setG23labels);
        if (!setG34.empty()) addQmlogLabelledSet(setG34,setG34labels);
    }

    if (!setG012.empty() || !setG123.empty() || !setG234.empty()) {
        booleanFunction->addQmlogLine("Set of size 4 implicants:");
        if (!setG012.empty()) addQmlogLabelledSet(setG012,setG012labels);
        if (!setG123.empty()) addQmlogLabelledSet(setG123,setG123labels);
        if (!setG234.empty()) addQmlogLabelledSet(setG234,setG234labels);
    }

    if (!setG0123.empty() || !setG1234.empty()) {
        booleanFunction->addQmlogLine("Set of size 8 implicants:");
        if (!setG0123.empty()) addQmlogLabelledSet(setG0123,setG0123labels);
        if (!setG1234.empty()) addQmlogLabelledSet(setG1234,setG1234labels);
    }

    if (!setG01234.empty()) {
        booleanFunction->addQmlogLine("Set of size 16 implicants:");
        if (!setG01234.empty()) addQmlogLabelledSet(setG01234,setG01234labels);
    }

    //if (setFinal.empty()) cout << "INTERNAL ERROR!" << endl;

    //cout << "QuineMcCluskey::minimize() add final set to log" << endl;

    booleanFunction->addQmlogLine("Final set:");
    addQmlogSet(setFinal);

    // create complete implicants set, this is directly used only to show the covering table, not in the algorithm
    booleanFunction->clearImplicants();    

    // PLAIN ORDER
    /*
    for (auto m : setFinal) {
        booleanFunction->addImplicants(m);
    }
    */

    // ORDERED BY NUMBER OF MINTERMS
    for (unsigned int n=1; n<=booleanFunction->getNumMinterms(); n=n*2) {
        for (auto m: setFinal) if (Biddy_CountMinterms(m,booleanFunction->getNumVariables()) == n) {
            booleanFunction->addImplicants(m);
        }
    }

    // WE PROCEED IN A SIMILAR WAY AS DESCRIBED BY PETRICK'S METHOD
    // https://en.wikipedia.org/wiki/Petrick's_method

    // CREATE LABELS FOR ALL IMPLICANTS
    // in the Biddy package, the added BDD variables are never removed
    // thus create also isupport that will be needed during the minterm extract
    unsigned int num = 0;
    map<Biddy_Edge,Biddy_Variable> implicants;
    Biddy_ClearVariablesData();
    Biddy_Edge isupport = Biddy_GetConstantOne();
    for (auto m : setFinal) {
        string varname = "i" + to_string(num++);
        Biddy_Variable var = Biddy_AddVariableByName((Biddy_String)varname.c_str());
        isupport = Biddy_And(isupport,Biddy_GetVariableEdge(var));
        Biddy_SetVariableData(var,new unsigned int(Biddy_DependentVariableNumber(m,FALSE)));
        implicants.insert(pair<Biddy_Edge,Biddy_Variable>(m,var));
        //cout << "IMPLICANT" << varname
        //     << ":" << booleanFunction2string(m)
        //     << "(" << *((unsigned int *)Biddy_GetVariableData(implicants.find(m)->second)) << "variables )"
        //     << "(" << numones(m) << "ones )" << endl;
    }

    // ADD LABELS TO ALL IMPLICANTS
    Biddy_Edge implicantsMatrix = Biddy_GetConstantZero();
    for (auto m : setFinal) {
        implicantsMatrix = Biddy_Or(implicantsMatrix,Biddy_And(m,Biddy_GetVariableEdge(implicants.find(m)->second)));
    }

    // CALCULATE THE BOOLEAN FUNCTION REPRESENTING SET OF SOLUTIONS - IT IS A PRODUCT OF COMPOUND LABELS
    Biddy_Edge implicantsMatrixWork = implicantsMatrix;
    Biddy_Edge implicantsMatrixTransformed = Biddy_GetConstantOne();
    while (implicantsMatrixWork != Biddy_GetConstantZero()) {
      //cout << "implicantsMatrixWork" << endl;
      //cout << booleanFunction2string(implicantsMatrixWork) << endl;
      Biddy_Edge targetMinterms = Biddy_ExtractMintermWithSupport(booleanFunction->getSupport(),implicantsMatrixWork);
      implicantsMatrixWork = Biddy_Gt(implicantsMatrixWork,targetMinterms);
      //cout << "targetMinterms:" << booleanFunction2string(targetMinterms) << endl;
      targetMinterms = Biddy_And(targetMinterms,booleanFunction->getBdd());
      //cout << "targetMinterms without dont't cares:" << booleanFunction2string(targetMinterms) << endl;
      if (targetMinterms != Biddy_GetConstantZero()) {
          Biddy_Edge targetImplicants = Biddy_ExistAbstract(Biddy_And(targetMinterms,implicantsMatrix),booleanFunction->getSupport());
          //cout << "targetImplicants" << booleanFunction2string(targetImplicants) << endl;
          implicantsMatrixTransformed = Biddy_And(implicantsMatrixTransformed,targetImplicants);
          //cout << "implicantsMatrixTransformed" << booleanFunction2string(implicantsMatrixTransformed) << endl;
      }
    }

    //cout << "implicantsMatrixTransformed:" << booleanFunction2string(implicantsMatrixTransformed) << endl;

    if (implicantsMatrixTransformed == Biddy_GetConstantZero()) {
        //cout << "QuineMcCluskey: ERROR IN THE ALGORITHM, implicantsMatrixTransformed == 0" << endl;
        booleanFunction->addSopImplicant("0");
        return;
    }

    Biddy_Edge allSolutions = implicantsMatrixTransformed;
    Biddy_Edge restrictedSolutions;
    unsigned int n;

    //cout << "allSolutions before restriction:" << booleanFunction2string(allSolutions) << endl;

    // MINIMIZE TOTAL NUMBER OF RESULTING VARIABLES
    n = 1;
    while ((restrictedSolutions = permitsymData(allSolutions,Biddy_GetLowestVariable(),n)) == Biddy_GetConstantZero()) n++;
    allSolutions = restrictedSolutions;

    //cout << "allSolutions after restriction to minimal resulting variables:" << booleanFunction2string(allSolutions) << endl;

    // MINIMIZE NUMBER OF PRODUCTS - NOT NEEDED
    /*
    n = 1;
    while ((restrictedSolutions = Biddy_Permitsym(allSolutions,n)) == Biddy_GetConstantZero()) n++;
    allSolutions = restrictedSolutions;
    */

    //cout << "allSolutions after restriction to minimal number of products:" << endl;
    //cout << booleanFunction2string(allSolutions) << endl;

    booleanFunction->clearSopSolutions();

    // manipulate all solutions
    while (allSolutions != Biddy_GetConstantZero()) {

        set<Biddy_Edge> essentialImplicants = set<Biddy_Edge>();

        Biddy_Edge oneSolution = Biddy_ExtractMintermWithSupport(isupport,allSolutions);
        allSolutions = Biddy_Gt(allSolutions,oneSolution); // gt(f,g) = and(f,not(g))

        //cout << "one solution:" << endl;
        //cout << booleanFunction2string(oneSolution) << endl;

        // calculate essential implicants for the choosen solution
        for (auto implicant : setFinal) {
            if (Biddy_And(oneSolution,Biddy_GetVariableEdge(implicants.find(implicant)->second)) == oneSolution)
            {
                //cout << "setEssential.insert:" << booleanFunction2string(implicant) << endl;
                essentialImplicants.insert(implicant);
            }
        }

        //cout << "setEssential:" << endl;
        //debugSet(essentialImplicants);

        // REPORT ALL ESSENTIAL SETS
        //booleanFunction->addQmlogLine("Essential set:");
        //addQmlogSet(essentialImplicants);

        booleanFunction->addSopSolutions(essentialImplicants);

    }

    booleanFunction->setSelectedSopSolution(0);

    //cout << "onset:" << booleanFunction->reportOnset() << endl;
    //cout << "implicants:" << booleanFunction->reportImplicants() << endl;

    //cout << "QuineMcCluskey::minimize() finished" << endl;
}

// update elements used gor GUI after changing the result
// this should be called after recalculation of all solutions and also after changing the choosen solution
void QuineMcCluskey::updateResults()
{
    //cout << "QuineMcCluskey: updateResults" << endl;

    if (booleanFunction->getSelectedSopSolution() >= booleanFunction->getNumSopSolutions()) {
        booleanFunction->clearSop();
        booleanFunction->clearCircles();
        //cout << "QuineMcCluskey: updateResults finished without actions" << endl;
        return;
    }

    set<Biddy_Edge> essentialImplicants = booleanFunction->getSopSolution(booleanFunction->getSelectedSopSolution());

    // SOP STRING
    booleanFunction->createSop(essentialImplicants);

    // SET OF CIRCLES
    booleanFunction->createCircles(essentialImplicants);

    // COVERING TABLE
    booleanFunction->createCoveringTable(essentialImplicants);

    // ONSET - THESE ARE MINTERMS - THIS CALL HERE IS FOR GUI DEBUGGING, ONLY
    //booleanFunction->createOnset();

    // IMPLICANTS - THESE ARE PRIME IMPLICANTS, A SUPERSET OF ESSENTIAL IMPLICANTS - THIS CALL HERE IS FOR GUI DEBUGGING, ONLY
    //booleanFunction->createImplicants();

    //cout << "QuineMcCluskey: updateResults finished" << endl;
}
