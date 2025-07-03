// Just a dummy program to be called by the runtime. Once development of the
// runtime is completed this will not be necessary. The entrypoint invoked by
// the runtime will be changed from `main` to `Main.main`, which is the default
// entrypoint of a COOL program.
extern void IO_out_string(char* x);

int main() {
    char x[32];
    // . . . .
    // 0 0 0 9
    x[7] = 0; x[6] = 0; x[5] = 0; x[4] = 10;

    // . . . .
    // . . . .
    // l l e h
    x[19] = 'l'; x[18] = 'l'; x[17] = 'e'; x[16] = 'h';

    // 0 0 \n o
    x[23] = 0; x[22] = 0; x[21] = '\n'; x[20] = 'o';

    IO_out_string(x);
    return 0;
}
