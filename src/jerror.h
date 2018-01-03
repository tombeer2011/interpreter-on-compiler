#ifndef JERROR_H
#define JERROR_H
#include "utility.h"

enum Stage {
    PREPROCESS, TOKENIZER, SYNTAXER, SEMANTICER
};

class Errorhandler {
public:

    static void handleIOError(string msg) {
        cout << "IO error :" << msg << endl;
        exit(1);
    }

    static void handleError(string msg, Stage stg, string filename, int line_number) {
        if (stg == PREPROCESS) {
            cout << "Preprocess Error: ";
        } else if (stg == TOKENIZER) {
            cout << "Tokenize Error: ";
        } else if(stg == SYNTAXER){
            cout << "Syntax Error: ";
        } else if (stg == SEMANTICER) {
            cout << "Semantic Error: ";
        }

        cout << filename << " at line " << line_number << "." << endl;
        cout << '\t' << msg << endl;
        exit(1);
    }

    static void handleWarning(string msg, Stage stg, string filename, int line_number) {
        if (stg == PREPROCESS) {
            cout << "Preprocess Warning: ";
        } else if (stg == TOKENIZER) {
            cout << "Tokenize Warning: ";
        } else {
            cout << "Syntax Warning: ";
        }

        cout << filename << " at line " << line_number << "." << endl;
        cout << '\t' << msg << endl;


    }
};

#endif // JERROR_H
