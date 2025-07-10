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
extern String* String_concat(String*, String*);

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
    length1.value = 6;

    String string1;
    string1.class_tag = 4;
    string1.object_size = 6;
    string1.dispatch_table = 0;
    string1.length = &length1;
    assign_string_content(&string1, "hello ", length1.value);

    pad_string_content(&string1, length1.value);

    Int length2;
    length2.class_tag = 2;
    length2.object_size = 4;
    length2.dispatch_table = 0;
    length2.value = 6;

    String string2;
    string2.class_tag = 4;
    string2.object_size = 6;
    string2.dispatch_table = 0;
    string2.length = &length2;
    assign_string_content(&string2, "world!", length2.value);

    pad_string_content(&string1, length1.value);

    String* string3 = String_concat(&string1, &string2);

    if (string3 != &string1 && string3 != &string2 && string3 != 0 && // string3 is a new String
        string3->length != string1.length && string3->length != string2.length && string3->length != 0 && // string3->length is a new Int
        string3->length->value == string1.length->value + string2.length->value) // concat has the right length
    {
        print_string("String_concat meta: ok\n", 23);
        IO io;
        IO_out_string(&io, string3);
        print_string("\n", 1);
    } else {
        print_string("String_concat meta: no\n", 23);
    }


    return 0;
}
