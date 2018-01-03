#ifndef PARSER_H
#define PARSER_H


#include "loader.h"
#include "asmwriter.h"
#include "utility.h"

class Parser {

    public:
        Parser(shared_ptr<vector<string>> _instructions, string _fileTag) {
            _filename = _fileTag + ".vm";
            loader = make_shared<Loader>(_instructions);
            writer = make_shared<Writer>(_fileTag + ".asm");
        }

        void parseFile() {
            auto instructions = loader->getInstructions();
            if (!instructions) return;
            int n = instructions->size();
            for (int i=0; i<n; i++) {
                auto linevec = instructions->at(i);

                if (linevec[0] == "pop" || linevec[0] == "push") writer->writePushorPop(linevec);
                else if (linevec[0] == "call") writer->writeCall(linevec);
                else if (linevec[0] == "function") writer->writeFunction(linevec);
                else if (linevec[0] == "return") {

                    writer-> writeReturn(linevec);
                }
                else if (linevec[0] == "add" ||
                         linevec[0] == "sub" ||
                         linevec[0] == "and" ||
                         linevec[0] == "or"  ||
                         linevec[0] == "neg" ||
                         linevec[0] == "eq"  ||
                         linevec[0] == "gt"  ||
                         linevec[0] == "lt"  ||
                         linevec[0] == "not" ||
                         linevec[0] == "xor"
                         ) writer->writeOperator(linevec);

                else if (linevec[0] == "label") writer->writeLabel(linevec);
                else if (linevec[0] == "if-goto") writer->writeIf(linevec);
                else if (linevec[0] == "goto") writer->writeGoto(linevec);
                else {

                }
            }
            writer->writeStatic();
        }
    private:
        shared_ptr<Loader> loader;
        shared_ptr<Writer> writer;
        string _filename;
};
#endif // PARSER_H

