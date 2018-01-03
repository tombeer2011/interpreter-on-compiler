#ifndef UTILITY_H
#define UTILITY_H

// C-lib
#include <errno.h>
#include <stdlib.h>
#include <limits.h>
#include <assert.h>
#include <unistd.h>
// IO
#include <cstdio>
#include <iostream>

// MATH
#include <cmath>

// STL
#include <vector>
#include <map>
#include <deque>
#include <string>
#include <queue>
#include <set>
#include <memory>
#include <fstream>
#include <sstream>
#include <stack>
#include <string>
// to make it easier to write.
using namespace std;

#include "jerror.h"

int ALIGN;
#define show(x) cout << (x) << endl;

int string2int(string s) {
    return atoi(s.c_str());
}

string char2string(char c) { // TODO: find a better way.
    string str;
    stringstream stream;
    stream << c;
    return stream.str();
}

string int2string(int val) {
    int n = val;
    stringstream ss;
    string s;
    ss << n;
    ss >> s;
    return s;
}

string getFileTag(string original) {
    int n = original.size()-1;
    while (original[n] != '.' && n != 0) { n--; }
    return string(original.begin(), original.begin() + n);
}

void writeToFile(shared_ptr<vector<string>> contents, string filename) {
    if (!contents) return;
    ofstream outfile(filename.c_str());
    for (auto line : *contents) {
        outfile << line << endl;
    }
}

bool startswith(string s, string t) {
    return s.find(t) == 0;
}

string get_underline_name(string funName) {
    int pos = funName.find('.');
    int n = funName.size();
    if (pos < n && pos > 0) {
       funName[pos] = '_';
    } else {
        cerr << "Something goes wrong! " << endl;
    }
    return funName;
}

void HandleBackendError(string filename, string msg) {
    cerr  << "Jana back end doesn't support "
          << "in "
          << filename
          << " : "
          << msg << endl;
    exit(1);
}


void HandleIOError(string filename, string msg) {
    cerr<< "IO Error " << "in "
        << filename << " : "<< msg << endl;
    exit(1);
}

#endif // UTILITY_H
