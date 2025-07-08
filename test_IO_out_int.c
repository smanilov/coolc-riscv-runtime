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

extern void IO_out_int(Int* );
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

// Compares the string content with the given string and returns 1 if they match
// or 0 otherwise.
char compare_string_content(String* string, char* content, int length) {
    for (int i = 0; i < length; ++i) {
        if (string->content[i] != content[i]) {
            return 0;
        }
    }
    return 1;
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
    Int x;
    x.class_tag = 2;
    x.object_size = 4;
    x.dispatch_table = 0;

    x.value = 0;
    IO_out_int(&x);
    print_string("\n", 1);

    x.value = 42;
    IO_out_int(&x);
    print_string("\n", 1);

    x.value = 401020;
    IO_out_int(&x);
    print_string("\n", 1);

    x.value = -12321;
    IO_out_int(&x);
    print_string("\n", 1);

    return 0;
}
