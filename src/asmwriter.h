#ifndef ASMWRITER_H
#define ASMWRITER_H
#include "jerror.h"
class Writer {
    public:
        Writer(string filename) :_fileName(filename) {
            out.open(filename, ios::out);
            if (!out)
                Errorhandler::handleIOError(filename + " can't open.");
            int n = filename.size()-1;
            while (filename[n] != '.') n--;
            fileNameTag = string(filename.begin(), filename.begin() + n);
            fileNameTag = removeSlashDot(fileNameTag);
            out << ".section .text" << endl;
        }

        void writePushorPop(vector<string> cmd) {
            int x = string2int(cmd[2]);
            if (cmd[1] == "constant") {
                out << '\t' << cmd[0] << "l $" << x << endl;
            } else if (cmd[1] == "local") {
                out << '\t' << "leal " << int2string(-4 * (x+3))
                    << "(" << "%ebp" << ")" << ", " << "%ecx" << endl;
                out << '\t' << cmd[0] << "l (%ecx)" << endl;
            } else if (cmd[1] == "argument") {
                // get the location of the taget, move to %ecx
                // (1) get the number of argument, store in %ecx
                out << '\t' << "movl 8(%ebp), %ecx" << endl;
                // (2) get the location of the target, move to %ecx
                out << '\t' << "leal " << int2string(8-4*x)
                    << "(%ebp,%ecx,4), %ecx" << endl;
                // (3) push
                out << '\t' << cmd[0] << "l (%ecx)" << endl;
            } else if (cmd[1] == "temp") {
                // %ebx point to 'temp 0'
                out << '\t' << cmd[0] << "l " << int2string((-4)*(x+4))
                    << "(%ebx)" << endl;
            } else if (cmd[1] == "static") {
                string val_name = string("static_") + fileNameTag + "_" + cmd[2];
                static_vals[val_name];
                out << '\t' << cmd[0] << "l " << val_name << endl;
            } else if (cmd[1] == "this") {
                 // 'this' pointer of this frame is now located @(ebx)
                 // (1)fetch it to the ecx
                 out << '\t' << "movl (%ebx), %ecx" << endl;
                 // (2)get the target's location, move to ecx
                 out << '\t' << "leal " << int2string(x*4)
                     << "(%ecx), %ecx" << endl;
                 // (3)
                 out << '\t' << cmd[0] << "l " << "(%ecx)" << endl;
            } else if (cmd[1] == "that") {
                // 'this' pointer of this frame is now located @ (ebx-4)
                 // (1) fetch it to the ecx
                 out << '\t' << "movl -4(%ebx), %ecx" << endl;
                 // (2) get the target's location, move to ecx
                 out << '\t' << "leal " << int2string(x*4)
                     << "(%ecx), %ecx" << endl;
                 // (3)
                 out << '\t' << cmd[0] << "l " << "(%ecx)" << endl;
            } else if (cmd[1] == "pointer") {
                if (x == 0) {
                    out << '\t' << cmd[0] << "l " << "(%ebx)" << endl;
                } else if (x == 1) {
                    out << '\t' << cmd[0] << "l " << "-4(%ebx)" << endl;
                }
            } else {
                HandleBackendError(_fileName, cmd[0] + cmd[1] + " not supported.");
            }
        }

        void writeCall(vector<string> cmd) {
            cmd[1] = get_underline_name(cmd[1]);
            // Have to handle some special cases; e.g. basic io & memory manager
            if (cmd[1] == "Output_printChar") {
                out << '\t' << "call putchar" << endl;
                return;
            } else if (cmd[1] == "Keyboard_readChar") {
                out << '\t' << "call getchar" << endl;
                out << '\t' << "pushl %eax" << endl;
                out << '\t' << "call putchar" << endl;
                return;
            } else if (cmd[1] == "Memory_alloc") {
                // make it 4 times because we are in x86 machine
                out << '\t' << "sall $2, (%esp)" << endl;
                out << '\t' << "call malloc" << endl;\
                out << '\t' << "movl %eax, (%esp)" << endl;
                return;
            } else if (cmd[1] == "Memory_deAlloc") {
                out << '\t' << "call free" << endl;
                return;
            } else if (cmd[1] == "Math_multiply") {
                out << '\t' << "popl %ecx" << endl;
                out << '\t' << "popl %edx" << endl;
                out << '\t' << "imull %ecx, %edx" << endl;
                out << '\t' << "pushl %edx" << endl;
                return;
            } else if (cmd[1] == "Math_divide") {
                out << '\t' << "popl %ecx" << endl;
                out << '\t' << "popl %eax" << endl;
                // get the sign bit, move to the ecx
                out << '\t' << "cltd" << endl;
                out << '\t' << "idivl %ecx" << endl;
                // quotient in eax and reminder in edx
                out << '\t' << "pushl %eax" << endl;
                return;
            } else if (cmd[1] == "Sys.halt") {
                out << '\t' <<  "movl $0, (%esp)" << endl;
                out << "call exit" << endl;
                return;
            }


            int argument_numbers = string2int(cmd[2]);
            out << '\t' << "pushl $" << cmd[2] << endl;
            out << '\t' << "call " << cmd[1] << endl;

            // in this model we have to make the stack pointer point to the first argument ;)
            // because the "ret" instruction can not do this job.
            out << '\t' << "addl $" << int2string(argument_numbers * 4)
                << ", %esp" << endl;
        }

        void writeReturn(vector<string> cmd) {
            // find the first argument' s location,
            // put the value which is in the stack-top(the return value),
            // to the position we just found;
            // (1) get the number of argument store in %ecx
            out << '\t' << "movl 8(%ebp), %ecx" << endl;
            // (2) get the location of the target to %ecx
            out << '\t' << "leal " << "8(%ebp,%ecx,4), %ecx" << endl;
            // (3) put the top-value to the target location.
            out << '\t' << "popl " << "(%ecx)" << endl;
            // (4) restore the this & that pointer
            out << '\t' << "movl -4(%ebp), %ecx" << endl;
            out << '\t' << "movl %ecx, (%ebx)" << endl;
            out << '\t' << "movl -8(%ebp), %ecx" << endl;
            out << '\t' << "movl %ecx, -4(%ebx)" << endl;
            out << '\t' << "leave" << endl;
            out << '\t' << "ret" << endl;
        }

        // note that we may have multi return statment in a function
        void writeFunction(vector<string> cmd) {
            if (!firstFunction) {
                out << '\t' << ".cfi_endproc" << endl;
            }  else {
                firstFunction = !firstFunction;
            }
            functionTag = removeSlashDot(cmd[1]);
            cmd[1] = get_underline_name(cmd[1]);
            out << '\t' << ".global " << cmd[1] << endl;
            out << cmd[1] << ":" << endl;
            out << '\t' << ".cfi_startproc" << endl;
            out << '\t' <<  "pushl %ebp" << endl;
            out << '\t' << "movl %esp, %ebp" << endl;
            out << '\t' << "pushl (%ebx)" << endl;
            out << '\t' << "pushl -4(%ebx)" << endl;
            int local_numbers = string2int(cmd[2]);
            int offset = 4 * local_numbers;
            out << '\t' << "subl $" << int2string(offset) << ", %esp" << endl;
        }

        void writeOperator(vector<string> cmd) {
            if (cmd[0] == "add") {
                out << '\t' << "popl %ecx" << endl;
                out << '\t' << "addl %ecx, (%esp)" << endl;
            } else if (cmd[0] == "sub") {
                out << '\t' << "popl %ecx" << endl;
                out << '\t' << "subl %ecx, (%esp)" << endl;
            } else if (cmd[0] == "neg") {
                out << '\t' << "negl (%esp)" << endl;
            } else if (cmd[0] == "not") {
                out << '\t' << "notl (%esp)" << endl;
            } else if (cmd[0] == "lt") {
                out << '\t' << "popl %edx" << endl;
                out << '\t' << "popl %ecx" << endl;
                out << '\t' << "cmpl %edx, %ecx" << endl;
                string trueflag = getTrueFlag("lt");
                string continueFlag = getContinueFlag("lt");
                out << '\t' << "jl " << trueflag << endl;
                // false
                out << '\t' << "pushl $0" << endl;
                out << '\t' << "jmp " << continueFlag << endl;
                out << trueflag << ":" << endl;
                out << '\t' << "pushl $-1" << endl;
                out << continueFlag << ":" << endl;
            } else if (cmd[0] == "gt") {
                out << '\t' << "popl %edx" << endl;
                out << '\t' << "popl %ecx" << endl;
                out << '\t' << "cmpl %edx, %ecx" << endl;
                string trueflag = getTrueFlag("lt");
                string continueFlag = getContinueFlag("lt");
                out << '\t' << "jg " << trueflag << endl;
                // false
                out << '\t' << "pushl $0" << endl;
                out << '\t' << "jmp " << continueFlag << endl;
                out << trueflag << ":" << endl;
                out << '\t' << "pushl $-1" << endl;
                out << continueFlag << ":" << endl;
            } else if (cmd[0] == "eq") {
                out << '\t' << "popl %edx" << endl;
                out << '\t' << "popl %ecx" << endl;
                out << '\t' << "cmpl %edx, %ecx" << endl;
                string trueflag = getTrueFlag("lt");
                string continueFlag = getContinueFlag("lt");
                out << '\t' << "je " << trueflag << endl;
                // false
                out << '\t' << "pushl $0" << endl;
                out << '\t' << "jmp " << continueFlag << endl;
                out << trueflag << ":" << endl;
                out << '\t' << "pushl $-1" << endl;
                out << continueFlag << ":" << endl;

            } else if (cmd[0] == "and") {
                out << '\t' << "popl %ecx" << endl;
                out << '\t' << "andl %ecx, (%esp)" << endl;
            } else if (cmd[0] == "or") {
                out << '\t' << "popl %ecx" << endl;
                out << '\t' << "orl %ecx, (%esp)" << endl;
            } else if (cmd[0] == "xor") {
                out << '\t' << "popl %ecx" << endl;
                out << '\t' << "xorl %ecx, (%esp)" << endl;
            } else {
                HandleBackendError(_fileName, cmd[0] + " not supported.");
            }
        }

        void writeLabel(vector<string> cmd) {
            string label = addFunctionTag(cmd[1]);
            out << label <<  ":" << endl;
        }

        void writeIf(vector<string> cmd) {
            string label = addFunctionTag(cmd[1]);
            out << '\t' << "movl (%esp), %ecx" << endl;
            out << '\t' << "testl %ecx, %ecx" << endl;
            out << '\t' << "jne " << label << endl;
        }

        void writeGoto(vector<string> cmd) {
            string label = addFunctionTag(cmd[1]);
            out << '\t' << "jmp " << label << endl;
        }

        void writeStatic() {
            // close the last function if needed
            if (!firstFunction) {
                out << '\t' << ".cfi_endproc" << endl;
            }

            out << ".section .data" << endl;
            for (auto p=static_vals.begin(); p!=static_vals.end(); p++) {
                string  val_name = p->first;
                out << '\t'  << ".global " << val_name << endl;
                out << val_name << ":" << endl;
                out << '\t' << ".long 0" << endl;
            }
        }

    private:
        string getTrueFlag(string op) {
            flag_true_counetr += 1;
            return string(".L") + fileNameTag + "_" + op + "_True_" + int2string(flag_true_counetr) ;

        }

        string getContinueFlag(string op) {
            flag_false_counter += 1;
            return string(".L") + fileNameTag + "_" + op + "_Continue_" + int2string(flag_false_counter) ;

        }

        string removeSlashDot(string origin) {
            for (unsigned i=0; i<origin.size(); i++) {
                if (origin[i] == '.' || origin[i] == '/') origin[i] = '_';
            }
            return origin;
        }

        string addFunctionTag(string label) {
            return string(".") + functionTag + "_" + label;
        }

        string fileNameTag;
        string _fileName; // fileNametag+".vm" == filename
        ofstream out;
        int flag_true_counetr = 0;
        int flag_false_counter = 0;
        map<string, int> static_vals;
        string functionTag;
        bool firstFunction = true;
};

#endif // ASMWRITER_H
