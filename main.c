// Just a dummy program to be called by the runtime. Once development of the
// runtime is completed this will not be necessary. The entrypoint invoked by
// the runtime will be changed from `main` to `Main.main`, which is the default
// entrypoint of a COOL program.
extern void Int_init(int* x);

int main() {
    int x[4];
    Int_init(x);
    return (int)(x);
}
