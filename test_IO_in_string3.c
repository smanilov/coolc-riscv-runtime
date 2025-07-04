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

extern String* IO_in_string(String*);
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
    Int length;
    length.class_tag = 2;
    length.object_size = 4;
    length.dispatch_table = 0;
    length.value = 12;

    String dummy;
    dummy.class_tag = 4;
    dummy.object_size = 6;
    dummy.dispatch_table = 0;
    dummy.length = &length;
    assign_string_content(&dummy, "xxxxxxxxabcd", length.value);
    // intentionally 12 chars, so we can check no more than 8 bytes are
    // overwritten

    String* read_string = IO_in_string(&dummy);
    if (compare_string_content(read_string, "hello\0\0\0abcd", 12)) {
        print_string("Pad is smol: ok\n", 16);
    } else {
        print_string("Pad is smol: no\n", 16);
    }

    return 0;
}
