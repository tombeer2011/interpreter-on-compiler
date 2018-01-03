#ifndef SYNTAXER_H
#define SYNTAXER_H
#include "tokenizer.h"
#include "symbol.h"
#include "vmwriter.h"

class Syntaxer {
public:

    Syntaxer(shared_ptr<vector<Primitive>> _ptr) :tkunits(_ptr), cur(0) {}
    //=====symbol table helper functions.=====
    int getSymbolIndexByName(string _name) {
        int sub_symbol_index = subSymbol.indexOfName(_name);

        if (sub_symbol_index == -1) { // maybe in class table
            int class_symbol_index = classSymbol.indexOfName(_name);
            if (class_symbol_index == -1) {
                Errorhandler::handleError(string("Unknown symbol : ")
                    + _name, SEMANTICER, getFilename(), getLineNum());
                return -1; //make compilers happy.
            } else {
                return class_symbol_index;
            }
        } else {
            return sub_symbol_index;
        }
    }

    string getSymbolKindByName(string _name) {
        int sub_symbol_index = subSymbol.indexOfName(_name);
        if (sub_symbol_index == -1) { // maybe in class table
            int class_symbol_index = classSymbol.indexOfName(_name);
            if (class_symbol_index == -1) {
                Errorhandler::handleError(string("Unknown symbol : ")
                    + _name, SEMANTICER, getFilename(), getLineNum());
                return "None";
            } else {
                return classSymbol.kindOfName(_name);
            }
        } else {
            return subSymbol.kindOfName(_name);
        }
    }

    string getSymbolTypeByName(string _name) {
        int sub_symbol_index = subSymbol.indexOfName(_name);
        if (sub_symbol_index == -1) { // maybe in class table
            int class_symbol_index = classSymbol.indexOfName(_name);
            if (class_symbol_index == -1) {
                Errorhandler::handleError(string("Unknown symbol : ")
                    + _name, SEMANTICER, getFilename(), getLineNum());
                return "None";
            } else {
                return classSymbol.typeOfName(_name);
            }
        } else {
            return subSymbol.typeOfName(_name);
        }
    }

    //=====functions for syntax analyze.=====
    void _class_() { // 'class' className '{' classVarDec* subrountineDec* '}'
        expect_string("class");
        ClassName = getContent();
        next();
        expect_string("{");
        while (getContent() == "static" || getContent() == "field") { _classVarDec(); }
        while (getContent() == "function"
            || getContent() == "method"
            || getContent() == "constructor") { _subRountine(); }
        expect_string("}");
        resetFlags();
    }
    void _classVarDec() { // ('static'|'field') type varName(, varName)*;
        string var_kind = getContent(); next();
        string var_type = getContent(); next();
        string var_name = getContent(); next();
        try {
            classSymbol.define(var_name, var_type, var_kind);
        } catch (RedefinataionException& e) {
            Errorhandler::handleError(string("Redefination of ")
                + var_name, SEMANTICER, getFilename(), getLineNum());
        }

        while (getContent() != ";") {
            expect_string(",");
            var_name = getContent(); next();
            try {
                classSymbol.define(var_name, var_type, var_kind);
            } catch (RedefinataionException& e) {
                Errorhandler::handleError(string("Redefination of ")
                    + var_name, SEMANTICER, getFilename(), getLineNum());
            }
        }
        expect_string(";");
    }

    void _parameterList() { // ((type varName) (',' type varName)) ?
        //if it is empty?
        if (getContent() == ")") {
            return;
        } else {
            while (1) {
                string var_type = getContent(); next();
                string var_name = getContent(); next();

                try {
                    subSymbol.define(var_name, var_type, "argument");
                } catch (RedefinataionException& e) {
                    Errorhandler::handleError(string("Redefination of ")
                        + var_name, SEMANTICER, getFilename(), getLineNum());
                }

                if (getContent() == ",") { next(); }
                else if (getContent() == ")") { break; }
                else { Errorhandler::handleError("unknown in parameterlist ",
                                        SYNTAXER, getFilename(), getLineNum()); }
            }
        }
    }
    void _subRountine() {    // ('constructor' | 'function' | 'method')
                            // ('void' | 'type') subruntineName '('
                            // parameterList ')' subroutineBody

        resetFlags();
        subSymbol.reset();
        string kind = getContent(); next();
        string ret_type = getContent(); next();
        string subrountineName = getContent(); next();
        curFunctionName = subrountineName;
        if (kind == "method") {
            try {
                // must be put here first. cause the argument will change.
                subSymbol.define("this", ClassName, "argument");
            } catch (RedefinataionException& e) {
                Errorhandler::handleError(string("Redefination of ")
                    + "this ", SEMANTICER, getFilename(), getLineNum());
            }

        } else if (kind == "function") {
            ;
        } else if (kind == "constructor") {
            ;
        } else {
            Errorhandler::handleError("unknown kind of sub rountine : ",
                SYNTAXER, getFilename(), getLineNum());
        }

        expect_string("(");
        _parameterList();
        expect_string(")");

        string functionName = ClassName + "." + subrountineName;
        // _subRontineBody : '{' varDec* statements '}'
        //  varDec: 'var' type varName (',' varName)* ';'
        expect_string("{");
        while (getContent() == "var") {
            next(); // pass the "var"
            string var_type = getContent(); next();
            string var_name = getContent(); next();

            try {
                subSymbol.define(var_name, var_type, "var");
            } catch (RedefinataionException& e) {
                Errorhandler::handleError(string("Redefination of ")
                    + var_name, SEMANTICER, getFilename(), getLineNum());
            }

            while (getContent() != ";") {
                expect_string(",");
                var_name = getContent(); next();

                try {
                    subSymbol.define(var_name, var_type, "var");
                } catch (RedefinataionException& e) {
                    Errorhandler::handleError(string("Redefination of ")
                        + var_name, SEMANTICER, getFilename(), getLineNum());
                }

            }
            expect_string(";");
        }

        int var_counter = subSymbol.kindCounter("var");
        writer.writeFunction(functionName, var_counter);

        if (kind == "method") {
            // let the THIS (in this frame) = argument 0 (THIS int the parent frame).
            writer.writePush("argument", 0);
            writer.writePop("pointer", 0);
        } else if (kind == "constructor") {
            int field_counter = classSymbol.kindCounter("field");
            // make space for the class passed to this pointer
            // bug fix
            writer.writePush("constant", field_counter);
            writer.writeCall("Memory.alloc", 1);
            writer.writePop("pointer", 0);
        }

        _stateMents();
        expect_string("}");
    }
    void _stateMents() { // statements: statement*
                         // statement:   letStatement | ifStatement | whileStatement |
                         // doStatement | returnStatement
        while (getContent() != "}") {
            if (getContent() == "let") {
                _letStatement();
            } else if (getContent() == "if") {
                _ifStatement();
            } else if (getContent() == "while") {
                _whileStatement();
            } else if (getContent() == "do") {
                _doStatement();
            } else if (getContent() == "return") {

                _returnStatement();
            } else if (getContent() == "for") {
                _forStatement();
            } else {
                Errorhandler::handleError("Unknown statement ",
                    SYNTAXER, getFilename(), getLineNum());
            }
        }
    }

    void _letOrdoStatement_nosemicolon() {
        if (getContent() == "do") {
            _doStatement_nosemicolon();
        } else if (getContent() == "let") {
            _letStatement_nosemicolon();
        } else {
            Errorhandler::handleError("Need let or do : ",
                SYNTAXER, getFilename(), getLineNum());
        }
    }

    void _letStatement() {
        _letStatement_nosemicolon();
        expect_string(";");
    }

    void _letStatement_nosemicolon () {  // letStatement:
                            //    'let' varName('[' expression ']') ? '='
                            //    expression
        expect_string("let");
        string var_name = getContent(); next();
        string var_type = getSymbolTypeByName(var_name);
        string var_kind = getSymbolKindByName(var_name);
        int var_idx = getSymbolIndexByName(var_name);

        if (getContent() == "[") {
            /* e.g. # let a[3] = 2;
            # push local 0
            # push constant 3
            # add
            # push constant 2
            # pop temp 0
            # pop pointer 1
            # push temp 0
            # pop that 0
            */
            // only class type not for Array
            if (var_type != "Array") {
                Errorhandler::handleError("Index only for Array",
                    SEMANTICER, getFilename(), getLineNum());
            }

            next();
            writer.writePush(var_kind, var_idx);
            _expression();
            expect_string("]");
            //! bug fix runtime error in assembly code x86, here we have to x 4
            writer.writePush("constant", ALIGN);
            writer.writeCall("Math.multiply", 2);
            //!
            writer.writeArithmetic("add");
            expect_string("=");

            _expression();
            writer.writePop("temp", 0);
            writer.writePop("pointer", 1);
            writer.writePush("temp", 0);
            writer.writePop("that", 0);

        }
        else if (getContent() == "=") {
            expect_string("=");
            _expression();
            writer.writePop(var_kind, var_idx);
        }
    }
    void _ifStatement() { // 'if' '(' expression ')' '{' statements '}'
                          //  ('else' '{' statements '}') ?
        string needed = int2string(if_flag_counter++);
        expect_string("if");
        expect_string("(");
        _expression();
        writer.writeArithmetic("not");
        writer.writeIf(string("IF_RIGHT") + needed);
        expect_string(")");
        expect_string("{");
        _stateMents();
        expect_string("}");

        if (getContent() == "else") {
            expect_string("else");
            expect_string("{");
            writer.writeGoto(string("IF_WRONG") + needed);
            writer.writeLabel(string("IF_RIGHT") + needed);
            _stateMents();
            expect_string("}");
            writer.writeLabel(string("IF_WRONG") + needed);
        }
        else {// don't have a else
            writer.writeLabel(string("IF_RIGHT") + needed);
        }
    }

    void _whileStatement() { // 'while' '(' expression ')' '{' statements '}'
        // inc 1 to while flag counter
        string needed = int2string(while_flag_counter++);
        writer.writeLabel(string("WHILE_START") + needed);
        expect_string("while");
        expect_string("(");
        _expression();
        expect_string(")");
        writer.writeArithmetic("not");
        writer.writeIf(string("WHILE_OVER") + needed);
        expect_string("{");
        _stateMents();
        expect_string("}");
        writer.writeGoto(string("WHILE_START") + needed);
        writer.writeLabel(string("WHILE_OVER") + needed);
    }

    void _forStatement() {

        string need = int2string(for_flag_counter++);
        expect_string("for");
        expect_string("(");
        _letOrdoStatement_nosemicolon();
        expect_string(";");

        writer.writeLabel(string("FOR_TEST") + need);
        _expression();

        expect_string(";");
        writer.writeArithmetic("not");
        writer.writeIf(string("FOR_OVER") + need);
        writer.writeGoto(string("FOR_STATE") + need);

        writer.writeLabel(string("FOR_INC") + need);
        _letOrdoStatement_nosemicolon();

        expect_string(")");
        writer.writeGoto(string("FOR_TEST") + need);

        writer.writeLabel(string("FOR_STATE") + need);
        expect_string("{");
        _stateMents();

        expect_string("}");
        writer.writeGoto(string("FOR_INC") + need);

        writer.writeLabel(string("FOR_OVER") + need);
    }

    void _doStatement() {
        _doStatement_nosemicolon();
        expect_string(";");
    }

    void _doStatement_nosemicolon() { //'do' subrountineCall ';'
        expect_string("do");
        _subroutineCall();
        writer.writePop("temp", 0);
    }
    void _returnStatement() {
        expect_string("return");
        returnStatementFlag = 1;
        if (getContent() == ";") {
            writer.writePush("constant", 0);
            expect_string(";");
            writer.writeReturn();
        } else {
            _expression();
            expect_string(";");
            writer.writeReturn();
        }
    }

    // ================================begin=======================================
    // 12 + 8
    // set<string> op = {"+", "-", "*", "/", "%", "&", "|", "!" ,
    //  "^", ">", "<", "==", "!=", "<=", ">=", "||", "&&"};

    void _expression() { // join (|| join)*
        _join();
        while (getContent() == "||") {
            next();
            _join();
            writer.writeCall("Math.or", 2);
        }
    }

    void _join() { // equality (&& equality)*
        _equality();
        while (getContent() == "&&") {
            next();
            _equality();
            writer.writeCall("Math.and", 2);
        }
    }

    void _equality() {
        _rel();
        while (getContent() == "==" || getContent() == "!=") {
            string operater = getContent();
            next();
            _rel();
            if (operater == "==") {
                writer.writeArithmetic("eq");
            } else {
                writer.writeCall("Math.noteq", 2);
            }
        }
    }

    void _rel() {
        _expr();
        while (getContent() == ">"
            || getContent() == "<"
            || getContent() == ">="
            || getContent() == "<=") {
            string operater = getContent();
            next();
            _expr();
            if (operater == ">") {
                writer.writeArithmetic("gt");
            } else if (operater == "<") {
                writer.writeArithmetic("lt");
            } else if (operater == "<=") {
                writer.writeCall("Math.lteq", 2);
            } else { // >=
                writer.writeCall("Math.gteq", 2);
            }
        }
    }

    void _expr() {
        _term();
        while (getContent() == "+" || getContent() == "-") {
            string operater = getContent();
            next();
            _term();
            if (operater == "+") {
                writer.writeArithmetic("add");
            } else {
                writer.writeArithmetic("sub");
            }
        }
    }


    void _term() {
        _mod_term();
        while (getContent() == "*" || getContent() == "/") {
            string operater = getContent();
            next();
            _mod_term();
            if (operater == "*") {
                writer.writeCall("Math.multiply", 2);
            } else {
                writer.writeCall("Math.divide", 2);
            }
        }
    }

    void _mod_term() {
        _bitWiseOrTerm();
        while (getContent() == "%") {
            next();
            _bitWiseOrTerm();
            writer.writeCall("Math.mod", 2);
        }
    }

    void _bitWiseOrTerm() {
        _XorTerm();
        while (getContent() == "|") {
            next();
            _XorTerm();
            writer.writeArithmetic("or");
        }
    }

    void _XorTerm() {
        _bitWiseAndTerm();
        while (getContent() == "^") {
            next();
            _bitWiseAndTerm();
            writer.writeArithmetic("xor");
        }
    }

    void _bitWiseAndTerm() {
        _prim_term();
        while (getContent() == "&") {
            next();
            _prim_term();
            writer.writeArithmetic("and");
        }
    }

    // =============================end============================================
    void _subroutineCall() { // subrountineName '(' expressionList ')' |
                             // (className | varName) '.' subrountineName '('
                             // expressionList ')'
        string first = getContent();
        expect_type(IDENTIFIER);
        if (getContent() == ".") {
            string classNameOrvarName = first;
            next();
            string subrountineName = getContent(); next();
            bool is_method = false;
            int sub_index = subSymbol.indexOfName(classNameOrvarName);
            string funNameWrite;
            if (sub_index == -1) {
                // not in the local symbol => it is Math.func() or field_instance.func();
                int class_index = classSymbol.indexOfName(classNameOrvarName);
                if (class_index == -1) { // it is Math.func()
                    funNameWrite = classNameOrvarName + "." + subrountineName;
                    is_method = false;
                } else { // field_instance.func()
                    is_method = true;
                    string type_ = classSymbol.typeOfName(classNameOrvarName);
                    int index_ = classSymbol.indexOfName(classNameOrvarName);
                    funNameWrite = type_ + "." + subrountineName;
                    writer.writePush("this", index_);
                }
            } else { // var_instance.func();
                is_method = true;
                string type_ = subSymbol.typeOfName(classNameOrvarName);
                string kind_ = subSymbol.kindOfName(classNameOrvarName);
                int index_ = subSymbol.indexOfName(classNameOrvarName);
                funNameWrite = type_ + "." + subrountineName;
                writer.writePush(kind_, index_);
            }

            expect_string("(");
            _expression_list();
            expect_string(")");

            if (is_method) {
                writer.writeCall(funNameWrite, getExpressionListNum() + 1);
            } else {
                writer.writeCall(funNameWrite, getExpressionListNum());
            }


        } else if (getContent() == "(") {
            // this kind is a subrountine call as well, just the method is in the class
            next(); // pass "("
            writer.writePush("pointer", 0);
            _expression_list();
            expect_string(")");

            string functionNameWrite = ClassName + "." + first;
            // and it is a method.
            writer.writeCall(functionNameWrite, getExpressionListNum() + 1);

        } else {
            // error
        }
    }

    void _prim_term() { // intConstant | strConstant | keywordConstant |
                   // varName | varName '[' expression ']' |
                   // subrountineCall | '(' expression ')' |
                   // unaryOp term
        if (getType() == INTCONST) {
            writer.writePush("constant", string2int(getContent()));
            next();
        } else if (getType() == STRCONST) {
            string content = getContent();
            int length = content.size();
            writer.writePush("constant", length);
            writer.writeCall("String.new", 1);
            for (unsigned i = 0; i < content.size(); i++) {
                writer.writePush("constant", content[i]);
                writer.writeCall("String.appendChar", 2);
            }
            next();
        } else if (getType() == KEYWORD) { // true, false, this, null
            if (getContent() == "true") {
                writer.writePush("constant", 1);
                writer.writeArithmetic("neg");
            } else if (getContent() == "false" || getContent() == "null") {
                writer.writePush("constant", 0);
            } else if (getContent() == "this") {
                writer.writePush("pointer", 0);
            }
            next();
        } else if (getType() == IDENTIFIER) {
            string var_name = getContent();
            next();
            if (getContent() == "[") { // varName '[' expression ']'
                string var_kind = getSymbolKindByName(var_name);
                string var_type = getSymbolTypeByName(var_name);
                if (var_type != "Array") {
                    Errorhandler::handleError("Index operation only for Array ",
                        SEMANTICER, getFilename(), getLineNum());
                }
                int var_index = getSymbolIndexByName(var_name);
                writer.writePush(var_kind, var_index);
                next();

                _expression();
                expect_string("]");

                //! bug fix
                writer.writePush("constant", ALIGN);
                writer.writeCall("Math.multiply", 2);

                writer.writeArithmetic("add");
                writer.writePop("pointer", 1);
                writer.writePush("that", 0);
            } else if (getContent() == "." || getContent() == "(") {
                moveBack();

                _subroutineCall();
            } else { // varName
                string var_kind = getSymbolKindByName(var_name);
                int var_index = getSymbolIndexByName(var_name);
                writer.writePush(var_kind, var_index);
            }
        } else if (getType() == SYMBOL) {
            if (getContent() == "(") { // '(' expression ')'
                next();
                _expression();
                expect_string(")");
            } else if (getContent() == "-" || getContent() == "!") { //unaryOp term
                string operater = getContent();
                next();
                _prim_term();
                if (operater == "-") writer.writeArithmetic("neg");
                else if (operater == "!") writer.writeCall("Math.not", 1);

            }
        }
    }
    void _expression_list() {
        expressionListNumStack.push_back(0);
        if (getContent() == ")") { return; }
        while (1) {
            _expression();
            expressionListNumStack[expressionListNumStack.size() - 1]++;
            if (getContent() == ",") {
                expect_string(",");
            } else if (getContent() == ")") {
                return;
            }
        }
    }

    // get the result of code writer.
    shared_ptr<vector<string>> getRes() { return writer.buffer; }

private:
    bool isBuiltIn(string type) { return (type == "boolean" || type == "int" || type == "char"); }
    // using the tokenizer's result.
    void moveBack() { if (cur > 0) cur -= 1; }
    void next() { if (cur < tkunits->size()) cur += 1; }
    Type getType() { return tkunits->at(cur).type; }
    size_t getLineNum() { return tkunits->at(cur).linenum; }
    string getContent() { return tkunits->at(cur).contents; }
    string getFilename() { return tkunits->at(cur).filename; }
    shared_ptr<vector<Primitive>> tkunits;
    size_t cur;

    // handle error or just pass
    void expect_string(string exp_str) {
        if (getContent() == exp_str)
            next();
        else {
            Errorhandler::handleError("Expect string: "
                + exp_str, SYNTAXER, getFilename() , getLineNum());
        }
    }
    void expect_type(Type exp_type) {
        if (getType() == exp_type)
            next();
        else {
            Errorhandler::handleError("Expect type: "
                + getTypeString(exp_type), SYNTAXER, getFilename(), getLineNum());
        }
    }

    // bug fix: user may call the function recursively
    int getExpressionListNum() {
        int ret = expressionListNumStack.back();
        expressionListNumStack.pop_back();
        return ret;
    }

    // for code-gen
    string ClassName; // current .. for the Class.function
    vector<int> expressionListNumStack; // for the instance.f(x, y, z)

    string curFunctionName;
    int returnStatementFlag;
    int firsttime = 1;

    int if_flag_counter = 0;
    int while_flag_counter = 0;
    int for_flag_counter = 0;

    void resetFlags() {
        if (firsttime) { firsttime = 0; }
        else {
           if (!returnStatementFlag) {
                Errorhandler::handleWarning("You may forgot the ret statement.",
                    SEMANTICER, ClassName + string(".") + curFunctionName, -1);
            }
        }
        returnStatementFlag = 0;
        for_flag_counter = if_flag_counter = while_flag_counter = 0;
    } // when function begin, call this function

    // symbol table for this class and the function which is parsing.
    Symbol classSymbol;
    Symbol subSymbol;

    // code writer
    VMWriter writer;
};
#endif
