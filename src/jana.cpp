
#include "tokenizer.h"
#include "syntaxer.h"
#include "loader.h"
#include "utility.h"
#include "parser.h"
#include "asmwriter.h"

vector<string> janafiles = {};
vector<string> vmfiles = {};
vector<string> asmfiles = {};
vector<string> objfiles = {};


bool isShowVM(const string& options) {
    for (auto ch: options) if (ch == 'v') return true;
    return false;
}

bool isHelp(const string& options) {
    for (auto ch: options) if (ch == 'h') return true;
    return false;
}

bool isShowAsm(const string& options) {
    for (auto ch: options) if (ch == 'a') return true;
    return false;
}

bool isShowObj(const string& options) {
    for (auto ch: options) if (ch == 'o') return true;
    return false;
}



void showHelp() {
    cout << endl << "Jana Compiler.(All Rights Reserved @zlq)." << endl;
    cout << "Usage:" << endl;
    cout << "./Jana -[hvao] (sourceFiles.jana)* -o target" << endl;
    cout << "-h  show help infomation." <<  endl;
    cout << "-v  show virtual machine files." << endl;
    cout << "-a  show x86 AT&T assembly files." << endl;
    cout << "-o  show object files." << endl;
    cout << "Example:" << endl;
    cout << "./Jana -h Main.jana Sub.jana -o MyProgram" << endl << endl;
}


int Assembler() {
    int n = janafiles.size();
    for (int i=0; i<n; i++) {
        int status;
        string cmd = string("as --32 ") + asmfiles[i] + " -o " + objfiles[i];
        status = system(cmd.c_str());
        if (status != 0) return -1;
    }
    return 0;
}

int Linker(const string& targetName) {
    string prefix = "ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 ./lib/libmyself.so -o " + targetName;
    string backfix = " -L/lib32 -lc";
    vector<string> built_in_lib = {"./lib/entry.o", "./lib/Math.o", "./lib/Array.o",
                                    "./lib/Keyboard.o", "./lib/String.o", "./lib/Output.o", "./lib/Sys.o"};
    string medium = " ";
    for (auto file: built_in_lib) {
        medium += " ";
        medium += file;
    }
    medium += " ";

    for (auto file: objfiles) {
        medium += " ";
        medium += file;
    }
    medium += " ";

    string cmd = prefix + medium + backfix;

    if (system(cmd.c_str())) return -1;
    return 0;
}

int Remover(const string& options) {
    string prefix = "rm -rf ";
    if (!isShowAsm(options)) {
        string cmd = prefix;
        for (auto file: asmfiles) {
            cmd += file;
            cmd += " ";
        }
        if (system(cmd.c_str())) return -1;
    }

    if (!isShowObj(options)) {
        string cmd = prefix;
        for (auto file: objfiles) {
            cmd += file;
            cmd += " ";
        }
        if (system(cmd.c_str())) return -1;
    }
    return 0;
}

int main(int argc, char** argv) {

    ALIGN = 4;
    if (argc == 1) {
        cerr << "> Use \'./Jana -h\' for help." << endl;
        return 0;
    }

    int begin = 2;
    string options = string(argv[1]);
    if (options[0] != '-') { options = ""; begin = 1; }

    if (isHelp(options)) {
        showHelp();
        return 0;
    }
    if (begin >= argc) {
        cerr << "please give some input files" << endl;
        return 0;
    }

    int i = begin;
    for (; i < argc; i++) {
        string tmp = string(argv[i]);

        if (tmp == "-o") {
            break;
        }
        string fileTag = getFileTag(tmp);
        janafiles.push_back(fileTag + ".jana");
        vmfiles.push_back(fileTag + ".vm");
        asmfiles.push_back(fileTag + ".asm");
        objfiles.push_back(fileTag + ".o");

        Tokenizer tk;
        auto tkunites = tk.getTkunits(tmp);
        Syntaxer syn(tkunites);
        syn._class_();
        shared_ptr<vector<string>> v2 = syn.getRes();


        if (isShowVM(options)) {
            writeToFile(v2, fileTag+".vm");
        }

        Parser p(v2, fileTag);
        p.parseFile();
    }


    string targetName = i+1<argc ? string(argv[i+1]) : "a.out";
    if (Assembler()) {
        cerr << "Assembler Error." << endl;
        return 0;
    }

    if (Linker(targetName)) {
        cerr << "Linker Error." << endl;
        return 0;
    }

    if (Remover(options)) {
        cerr << "Remove Files Error." << endl;
        return 0;
    }

    return 0;

}
