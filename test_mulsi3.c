typedef struct {
    int class_tag;
    int object_size;
    void* dispatch_table;
    int value;
} Int;

typedef struct {
    int class_tag;
    int object_size;
    void* dispatch_table;
    Int* length;
    char content[256]; // for testing purposes, length is fixed at 256
} String;

extern void IO_out_string(String* x);

void assign_string_content(String* string, char* content, int length) {
    for (int i = 0; i < length; ++i) {
        string->content[i] = content[i];
    }
}

// Given a String and the length of the actual content, adds a terminating 0,
// and then adds 0 bytes so that the length becomes a multiple of 4.
void pad_string_content(String* string, int length) {
    string->content[length++] = '0';
    while (length % 4 != 0) {
        string->content[length++] = '0';
    }
}

// Prints a string using IO_out_string.
void print_string(char* content, int length) {
    Int l;
    l.class_tag = 2;
    l.object_size = 4;
    l.dispatch_table = 0;
    l.value = length;

    String string;
    string.class_tag = 4;
    string.object_size = 6;
    string.dispatch_table = 0;
    string.length = &l;
    assign_string_content(&string, content, length);

    pad_string_content(&string, length);

    IO_out_string(&string);
}

int main() {
    int x = 10;
    int y = 20;

    // if extension `m' or `zmmul' is not used, GCC will generate __mulsi3
    // intrinsic for x * y
    print_string(x * y == 200 ? "PASSED\n" : "FAILED\n", 7);

    return 0;
}
