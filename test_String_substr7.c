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
extern String* String_substr(String*, Int*, Int*);

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

    IO io;
    IO_out_string(&io, &string);
}

int main() {
    Int length1;
    length1.class_tag = 2;
    length1.object_size = 4;
    length1.dispatch_table = 0;
    length1.value = 12;

    String string1;
    string1.class_tag = 4;
    string1.object_size = 6;
    string1.dispatch_table = 0;
    string1.length = &length1;
    assign_string_content(&string1, "hello world!", length1.value);

    pad_string_content(&string1, length1.value);

    Int from;
    from.class_tag = 2;
    from.object_size = 4;
    from.dispatch_table = 0;
    from.value = 0;

    Int length;
    length.class_tag = 2;
    length.object_size = 4;
    length.dispatch_table = 0;
    length.value = 12;

    String* substr = String_substr(&string1, &from, &length);
    if (substr != &string1 && substr != 0 && // substr is a new String
        substr->length != string1.length &&
        substr->length != &from &&
        substr->length != &length &&
        substr->length != 0 && // substr->length is a new Int
        substr->length->value == length.value) // substr has the right length
    {
        print_string("String_substr meta: ok\n", 23);
        IO io;
        IO_out_string(&io, substr); // expected: "hello world!"
        print_string("\n", 1);
    } else {
        print_string("String_concat meta: no\n", 23);
    }

    return 0;
}
