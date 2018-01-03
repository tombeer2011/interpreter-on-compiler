#ifndef TOKENIZER_H
#define TOKENIZER_H

#include "jerror.h"
#define ISDIGIT(ch)         ((ch) >= '0' && (ch) <= '9')
#define ISDIGIT1TO9(ch)     ((ch) >= '1' && (ch) <= '9')
#define ISALPHA(c)            (isalpha(c) || (c) == '_')
#define ISWHITE(c)            ((c) == ' ' || (c) == '\t' || (c) == '\n' || (c) == '\r')

enum Type {KEYWORD, SYMBOL, INTCONST, STRCONST, IDENTIFIER};

string getTypeString(Type x) {
    switch (x) {
        case KEYWORD:
            return "KEYWORD";

        case SYMBOL:
            return "SYMBOL";

        case INTCONST:
            return "INTCONST";

        case STRCONST:
            return "STRCONST";

        case IDENTIFIER:
            return "IDENTIFIER";

        default:
            break;
    }
    return "None";
}

struct Primitive {
    Primitive(Type _type, string _contents, int _linenum, string _filename) :
        type(_type), contents(_contents), linenum(_linenum), filename(_filename) {}
    Type type;
    string contents;
    size_t linenum;
    string filename;
};

class Tokenizer {
public:
    Tokenizer() {
        tkunits = make_shared<vector<Primitive>>();
        line_number = 1;
    }
    shared_ptr<vector<Primitive>> getTkunits(string filename) {
        this->filename = filename;
        processFile(filename);
        removeComments_type1();
        removeComments_type2();
        // add a dummy node
        this->fileStr += '\0';
        const char* p = this->fileStr.c_str();
        while (1) {
            if (ISWHITE(*p)) parse_white(p);
            string tmp = char2string(*p);
            if (ISDIGIT(*p))  parse_num(p);
            else if (ISALPHA(*p)) parse_word(p);
            else if (*p == '\"')  parse_const_string(p);
            else if (*p == '\0')  break;
            else if (isSymbol(tmp)) {
                ++p;
                if (*p) {
                    string test_tmp = tmp + *p;
                    if (isDoubleSymbol(test_tmp)) {
                        ++p;
                        this->tkunits->push_back(Primitive(SYMBOL, test_tmp, line_number, getFilename()));
                    } else {
                        this->tkunits->push_back(Primitive(SYMBOL, tmp, line_number, getFilename()));
                    }
                } else {
                    this->tkunits->push_back(Primitive(SYMBOL, tmp, line_number, getFilename()));
                }

            } else {
                Errorhandler::handleError("Unknown token unit: ", TOKENIZER, getFilename(), line_number);
            }

        }
        return this->tkunits;
    }
    string getFilename() { return this->filename; }

private:

    bool isSymbol(string tk) {
        for (auto x : this->symbols)
            if (x == tk) return true;
        return false;
    }
    bool isKeyword(string tk) {
        for (auto x : this->keywords)
            if (x == tk) return true;
        return false;
    }
    bool isDoubleSymbol(string tk) {
        for (auto x: this->doubleCharsysmbols)
            if (x == tk) return true;
        return false;
    }
    void processFile(string filename) {
        ifstream inputfile;
        inputfile.open(filename.c_str());
        if (!inputfile) {
            Errorhandler::handleIOError(string("can't open file: ") + filename);
        }
        stringstream inputstream;
        inputstream << inputfile.rdbuf();
        this->fileStr = inputstream.str();
    }
    void removeComments_type1() { /* remove this kind of comments */
        string source = this->fileStr;
        bool flag = 1;
        string res;
        int n = source.size();
        for (int i = 0; i < n; i++) {
            // the total line number doesn't change.
            if (source[i] == '\n') {
                res += source[i];
                continue;
            }

            if (source[i] == '/' && i < n - 1 && source[i + 1] == '*') {
                if (flag == 1) flag = 0;
                i += 1;
            }
            else if (source[i] == '*' && i < n - 1 && source[i + 1] == '/') {
                if (flag == 0) flag = 1;
                i += 1;
            }
            else {
                if (flag == 0) continue;
                else res += source[i];
            }
        }
        this->fileStr = res;
    }
    void removeComments_type2() { // remove this kind of comments
        string source = this->fileStr;
        bool flag = 0; // outside for default
        string res;
        for (unsigned i = 0; i < source.size(); i++) {
            if (source[i] == '/' && i + 1 < source.size() && source[i + 1] == '/') {
                if (!flag) flag = 1;
                i += 1;
            } else if (source[i] == '\n') {
                if (flag) flag = 0;
                    res += source[i];
            } else {
                if (!flag) res += source[i];
            }
        }
        this->fileStr = res;
    }

    void parse_white(const char *&p) {
        while (*p == ' ' || *p == '\t' || *p == '\n' || *p == '\r') {
            if (*p == '\n') line_number += 1;
            p++;
        }
    }
    void parse_num(const char*& p) {
        string res;
        while (ISDIGIT(*p)) {
            res += *p;
            p++;
        }
        this->tkunits->push_back(Primitive(INTCONST, res, line_number, getFilename()));
    }
    void parse_word(const char*& p) {
        string res;
        while (ISALPHA(*p) || ISDIGIT(*p)) {
            res += *p;
            p++;
        }
        Type tmp;
        if (isKeyword(res)) tmp = KEYWORD;
        else                tmp = IDENTIFIER;
        this->tkunits->push_back(Primitive(tmp, res, line_number, getFilename()));

    }
    // it is a identifier or a keyword.
    void parse_const_string(const char* &p) {
        assert(*p == '\"');
        const char* b = p + 1;
        string res;
        while (1) {
            // TODO: if (*b == '\0')handle_error
            if (*b == *p) {
                ++b; break;
            } else if (*b == '\\') {
                    ++b;
                    char ch = *b;
                    char c;
                    switch (ch) {
                        case '0':
                            c = '\0';
                            break;
                        case 'a':
                            c = '\a';
                            break;
                        case 'b':
                            c = '\b';
                            break;
                        case 't':
                            c = '\t';
                            break;
                        case 'n':
                            c = '\n';
                            break;
                        case 'v':
                            c = '\v';
                            break;
                        case 'f':
                            c = '\f';
                            break;
                        case 'r':
                            c = '\r';
                            break;
                        case '\"':
                            c = '\"';
                            break;
                        case '\'':
                            c = '\'';
                            break;
                        case '\\':
                            c = '\\';
                            break;
                        default:
                            // handle_error.
                            break;
                    }
                res += c;
                ++b;
            } else {
                res += *b;
                ++b;
            }
        }
        p = b;
        this->tkunits->push_back(Primitive(STRCONST, res, line_number, getFilename()));

    }

    vector<string> symbols = { "{" , "}", "(",  ")", "[", "]", ".", ",",
        ";",  "+",  "-",  "*", "/", "&", "|",  "<", ">",  "%" , "!",  "=", "~", "^"};

    vector<string> doubleCharsysmbols = { "||", "&&",  "!=", ">=", "<=", "==", "<<", ">>"};

    vector<string> keywords = {
        "class" , "constructor",  "function" ,
        "method" , "field" , "static" , "var" ,
        "int" ,  "char" , "boolean" , "void" ,
        "true" , "false" , "null" , "this" , "let" ,
        "do" , "if" , "else" , "while" , "return", "for"
    };

    string fileStr;
    string filename;
    int line_number;
    shared_ptr<vector<Primitive>> tkunits;
};

#endif
