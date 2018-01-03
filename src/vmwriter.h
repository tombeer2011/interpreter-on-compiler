#ifndef VMWRITER_H
#define VMWRITER_H


class VMWriter {

public:

    VMWriter() { buffer = make_shared<vector<string>>(); }

    void writePush(string segment, int idx) {
        string res = string("push ") + segment + " " + int2string(idx);
        buffer->push_back(res);
    }

    void writePop(string segment, int idx) {
        string res = string("pop ") + segment + " " + int2string(idx);
        buffer->push_back(res);
    }

    void writeArithmetic(string cmd) {
        buffer->push_back(cmd);
    }

    void writeFunction(string functionName, int LclNum) {
        string res = string("function ") + functionName + " " + int2string(LclNum);
        buffer->push_back(res);
    }

    void writeReturn() { buffer->push_back(string("return")); }

    void writeCall(string functionName, int ELNum) {
        string res = string("call ") + functionName + " " + int2string(ELNum);
        buffer->push_back(res);
    }

    void writeLabel(string label) {
        string res = string("label ") + label;
        buffer->push_back(res);
    }

    void writeGoto(string label) {
        string res = string("goto ") + label;
        buffer->push_back(res);
    }

    void writeIf(string label) {
        string res = string("if-goto ") + label;
        buffer->push_back(res);
    }

    shared_ptr<vector<string>> buffer;

};

#endif // VMWRITER_H

