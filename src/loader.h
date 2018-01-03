#ifndef LOADER_H
#define LOADER_H

#include "utility.h"

class Loader {
    public:
        Loader(shared_ptr<vector<string>> _instructionsVec) {
            if (!_instructionsVec) return;
            this->instructions = make_shared<vector<vector<string>>>();
            for (auto str: *_instructionsVec) {
                parseLine(str);
            }
        }

        void parseLine(string aline) { // like a preprocessor handle some special cases.
            istringstream is(aline);
            vector<string> aline_vec;
            string tmp;
            while (is >> tmp) {
                aline_vec.push_back(tmp);
            }
            instructions->push_back(aline_vec);
        }
        shared_ptr<vector<vector<string>>> getInstructions() {
            return instructions;
        }

    private:
        shared_ptr<vector<vector<string>>> instructions;

};
#endif
