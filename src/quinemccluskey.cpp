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
             << (isImplicant(m) ? " - IMPLICANT" : " - NOT IMPLICANT")
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
            //cout << "QuineMcCluskey::addQmlogSet ELEMENT: " << implicant2string(m) << endl;
            //cout << implicant2symbol(booleanFunction->getSupport(),m) << endl;
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
    //cout << "QuineMcCluskey::minimize() started" << endl;
    //cout << booleanFunction->getBits() << endl;
    //cout << booleanFunction2string(booleanFunction->getBdd()) << endl;

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

    //cout << "QuineMcCluskey::minimize() create init set" << endl;

    // HERE COMES THE QUINE-MCCLUSKEY ALGORITHM
    set<Biddy_Edge> setInit = createInitSet();
    set<Biddy_Edge> setFinal;

    //debugSet(setInit);

    // STEP 1: finding prime implicants

    vector<vector<set<Biddy_Edge>>> setG(booleanFunction->getNumVariables()+1); // constructor creates vector of empty vectors
    vector<vector<set<Biddy_Edge>>> setGlabels(booleanFunction->getNumVariables()+1); // constructor creates vector of empty vectors

    // STEP 1a: create empty structures setG and setGlabels
    for (unsigned int i=0; i<=booleanFunction->getNumVariables(); i++) {
        for (unsigned int j=0; j<=(booleanFunction->getNumVariables()-i); j++) {
          setG[i].push_back(set<Biddy_Edge>());
          setGlabels[i].push_back(set<Biddy_Edge>());
        }
    }

    // STEP 1b: group based on the number of 1s present in their binary equivalents
    for (auto elem : setInit) setG[0][numones(elem)].insert(elem);

    // STEP 1c: concatenate groups
    for (unsigned int i=0; i<=booleanFunction->getNumVariables()-1; i++) {
        for (unsigned int j=0; j<=booleanFunction->getNumVariables()-i-1; j++) {
            for (auto elem1 : setG[i][j]) {
                for (auto elem2 : setG[i][j+1]) {
                    if (isAdjacent(elem1,elem2)) {
                        setGlabels[i][j].insert(elem1);
                        setGlabels[i][j+1].insert(elem2);
                        setG[i+1][j].insert(Biddy_Or(elem1,elem2));
                    }
                }
            }
        }
    }

    // collect all implicants that seems to be candidates for prime implicants...
    // ... (it is not in setGlabels - it does not have adjacent implicant) and (it is not redundant - it does not include only don't care minterms)

    // add all redundant implicants to setGlabels, not all of them were collected in previous algorithm
    for (unsigned int i=0; i<=booleanFunction->getNumVariables(); i++) {
        for (unsigned int j=0; j<=(booleanFunction->getNumVariables()-i); j++) {
            for (auto m : setG[i][j]) if (isRedundant(m)) setGlabels[i][j].insert(m);
        }
    }

    // collect all prime implicants
    for (unsigned int i=0; i<=booleanFunction->getNumVariables(); i++) {
        for (unsigned int j=0; j<=(booleanFunction->getNumVariables()-i); j++) {
            for (auto m : setG[i][j]) if (setGlabels[i][j].empty() || (setGlabels[i][j].find(m) == setGlabels[i][j].end())) setFinal.insert(m);
        }
    }

    // STEP 1d: write results to log

    booleanFunction->addQmlogLine("Set of cubes:");
    for (unsigned int i=0; i<=booleanFunction->getNumVariables(); i++) {
        if (!setG[0][i].empty()) addQmlogLabelledSet(setG[0][i],setGlabels[0][i]);
    }

    unsigned int thesize = 1;
    for (unsigned int i=1; i<=booleanFunction->getNumVariables(); i++) {
        thesize = thesize * 2;
        bool OK = false;
        for (unsigned int j=0; j<=booleanFunction->getNumVariables()-i; j++) OK = OK || (!setG[i][j].empty());
        if (OK) {
            booleanFunction->addQmlogLine("Set of size " + to_string(thesize) + " implicants:");
            for (unsigned int j=0; j<=booleanFunction->getNumVariables()-i; j++) {
                if (!setG[i][j].empty()) addQmlogLabelledSet(setG[i][j],setGlabels[i][j]);
            }
        }
    }

    //if (setFinal.empty()) cout << "INTERNAL ERROR!" << endl;

    //cout << "QuineMcCluskey::minimize() add final set to log" << endl;

    booleanFunction->addQmlogLine("Final set:");
    addQmlogSet(setFinal);

    // STEP 2: create complete implicants set
    // this is directly used only to show the covering table, not in the algorithm

    booleanFunction->clearImplicants();

    // VARIANT A: PLAIN ORDER
    /*
    for (auto m : setFinal) {
        booleanFunction->addImplicants(m);
    }
    */

    // VARIANT B: ORDERED BY NUMBER OF MINTERMS
    for (unsigned int n=1; n<=booleanFunction->getNumMinterms(); n=n*2) {
        for (auto m: setFinal) if (Biddy_CountMinterms(m,booleanFunction->getNumVariables()) == n) {
            booleanFunction->addImplicants(m);
        }
    }

    // STEP 3: FIND ALL SOLUTIONS - WE PROCEED IN A SIMILAR WAY AS DESCRIBED BY PETRICK'S METHOD
    // https://en.wikipedia.org/wiki/Petrick's_method

    // STEP 3a: CREATE LABELS FOR ALL IMPLICANTS
    // in the Biddy package, the added BDD variables are never removed
    // thus we create also function isupport that will be needed during the minterm extract
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

    // STEP 3b: ADD LABELS TO ALL IMPLICANTS
    Biddy_Edge implicantsMatrix = Biddy_GetConstantZero();
    for (auto m : setFinal) {
        implicantsMatrix = Biddy_Or(implicantsMatrix,Biddy_And(m,Biddy_GetVariableEdge(implicants.find(m)->second)));
    }

    // STEP 3c: CALCULATE THE BOOLEAN FUNCTION REPRESENTING SET OF SOLUTIONS - IT IS A PRODUCT OF COMPOUND LABELS
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
        booleanFunction->addSopImplicant("0");
        return;
    }

    // STEP 4: CREATE RESTRICTED SOLUTIONS

    Biddy_Edge allSolutions = implicantsMatrixTransformed;
    Biddy_Edge restrictedSolutions;
    unsigned int n;

    //cout << "allSolutions before restriction:" << booleanFunction2string(allSolutions) << endl;

    // STEP 4a: MINIMIZE TOTAL NUMBER OF RESULTING VARIABLES
    n = 1;
    while ((restrictedSolutions = permitsymData(allSolutions,Biddy_GetLowestVariable(),n)) == Biddy_GetConstantZero()) n++;
    allSolutions = restrictedSolutions;

    //cout << "allSolutions after restriction to minimal resulting variables:" << booleanFunction2string(allSolutions) << endl;

    // STEP 4b: MINIMIZE NUMBER OF PRODUCTS - NOT NEEDED
    /*
    n = 1;
    while ((restrictedSolutions = Biddy_Permitsym(allSolutions,n)) == Biddy_GetConstantZero()) n++;
    allSolutions = restrictedSolutions;
    */

    //cout << "allSolutions after restriction to minimal number of products:" << endl;
    //cout << booleanFunction2string(allSolutions) << endl;

    booleanFunction->clearSopSolutions();

    // STEP 4c: MANIPULATE ALL SOLUTIONS
    while (allSolutions != Biddy_GetConstantZero()) {

        set<Biddy_Edge> essentialImplicants = set<Biddy_Edge>();
        Biddy_Edge oneSolution = Biddy_ExtractMintermWithSupport(isupport,allSolutions);

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
        allSolutions = Biddy_Gt(allSolutions,oneSolution); // gt(f,g) = and(f,not(g))

    }


    // STEP 5: THE FIRST SOLUTION BECOMES THE SELECTED SOLUTION
    // there may exist only one or multiple solutions, but solution 0 should always exists

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
