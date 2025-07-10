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

typedef struct {
    int class_tag;
    int object_size;
    void* dispatch_table;
} IO;

extern void IO_out_string(IO*, String*);
extern String* Object_type_name(void* x);

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

    IO io;
    IO_out_string(&io, &string);
}

int main() {
    Int length;
    length.class_tag = 2;
    length.object_size = 4;
    length.dispatch_table = 0;
    length.value = 5;

    String string;
    string.class_tag = 4;
    string.object_size = 6;
    string.dispatch_table = 0;
    string.length = &length;
    assign_string_content(&string, "hello", 5);

    String* y = Object_type_name((void*)&string);
    IO io;
    IO_out_string(&io, y); // expected: String

    print_string("\n", 1);

    String* z = Object_type_name((void*)&length);
    IO_out_string(&io, z); // expected: Int

    print_string("\n", 1);

    return 0;
}
