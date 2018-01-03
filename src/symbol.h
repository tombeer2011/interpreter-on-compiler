#ifndef SYMBOL_H
#define SYMBOL_H

class RedefinataionException: public exception {
    public:
    RedefinataionException() {}
};

class Symbol {

public:
    Symbol() { reset(); }

    void reset() {
        name.clear();
        type.clear();
        kind.clear();
        index.clear();
    }

    int foundName(string _name) {
        for (unsigned i = 0; i < name.size(); i++) {
            if (name[i] == _name) { return i; }
        }
        return -1;
    }


    void define(string _name, string _type, string _kind) {

        if (foundName(_name) != -1) { throw RedefinataionException(); }

        if (_kind == "field") _kind = "this";
        if (_kind == "var") _kind = "local";
        int this_kind_number = kindCounter(_kind);

        name.push_back(_name);
        type.push_back(_type);
        kind.push_back(_kind);
        index.push_back(this_kind_number);

    }

    int kindCounter(string _kind) {
        if (_kind == "field") _kind = "this";
        if (_kind == "var") _kind = "local";
        int res = 0;
        for (unsigned i = 0; i < name.size(); i++) {
            if (kind[i] == _kind) {
                res += 1;
            }
        }
        return res;
    }

    string kindOfName(string _name) {
        for (unsigned i = 0; i < name.size(); i++) {
            if (_name == name[i]) {
                return kind[i];
            }
        }
        return "None";
    }

    string typeOfName(string _name) {
        for (unsigned i = 0; i < name.size(); i++) {
            if (_name == name[i]) {
                return type[i];
            }
        }
        return "None";
    }

    int indexOfName(string _name) {
        for (unsigned i = 0; i < name.size(); i++) {
            if (_name == name[i]) {
                return index[i];
            }
        }
        return -1;
    }

    vector<string> name;
    vector<string> type;
    vector<string> kind;
    vector<int> index; // index of a kind
};

#endif // SYMBOL_H
