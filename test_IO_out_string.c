// Just a dummy program to be called by the runtime. Once development of the
// runtime is completed this will not be necessary. The entrypoint invoked by
// the runtime will be changed from `main` to `Main.main`, which is the default
// entrypoint of a COOL program.
extern void IO_out_string(char* x);

int main() {
    char x[32];
    // offset +0 is the class tag; ignored by the function
    // . . . .

    // offset +4 is where the size of the object is stored in words;
    //
    // 0 0 0 6
    x[7] = 0; x[6] = 0; x[5] = 0; x[4] = 6;

    // offset +8 is the dispatch table; ignored by the function
    // . . . .

    // offset +12 is the Int storing the length; TODO: read
    // . . . .

    // offset +16 is where the string contents start
    // l l e h
    x[19] = 'l'; x[18] = 'l'; x[17] = 'e'; x[16] = 'h';

    // terminate with 0 and fill to word boundary
    // 0 0 \n o
    x[23] = 0; x[22] = 0; x[21] = '\n'; x[20] = 'o';

    IO_out_string(x);
    return 0;
}
