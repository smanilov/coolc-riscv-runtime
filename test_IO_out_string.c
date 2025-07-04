// Just a dummy program to be called by the runtime. Once development of the
// runtime is completed this will not be necessary. The entrypoint invoked by
// the runtime will be changed from `main` to `Main.main`, which is the default
// entrypoint of a COOL program.
extern void IO_out_string(char* x);

int main() {
    char length[16];
    // offset +0 is the class tag; ignored by the function
    // . . . .

    // offset +4 is the object size; ignored by the function
    // . . . .

    // offset +8 is the dispatch table; ignored by the function
    // . . . .

    // offset +12 is the value
    // 0 0 0 6
    length[15] = 0; length[14] = 0; length[13] = 0; length[12] = 6;

    char string[32];
    // offset +0 is the class tag; ignored by the function
    // . . . .

    // offset +4 is where the size of the object is stored in words;
    //
    // 0 0 0 6
    string[7] = 0; string[6] = 0; string[5] = 0; string[4] = 6;

    // offset +8 is the dispatch table; ignored by the function
    // . . . .

    // offset +12 is the Int storing the length; TODO: read
    // <address-of-length>
    *((int*)(string + 12)) = (int)(length);

    // offset +16 is where the string contents start
    // l l e h
    string[19] = 'l'; string[18] = 'l'; string[17] = 'e'; string[16] = 'h';

    // terminate with 0 and fill to word boundary
    // 0 0 \n o
    string[23] = 0; string[22] = 0; string[21] = '\n'; string[20] = 'o';

    IO_out_string(string);
    return 0;
}
