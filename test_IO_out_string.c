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
    char content[32]; // for testing purposes, length is fixed at 32
} String;

extern void IO_out_string(String* x);

void assign_string_content(String* string, char* content, int length) {
    for (int i = 0; i < length; ++i) {
        string->content[i] = content[i];
    }
}

int main() {
    Int length;
    length.class_tag = 2;
    length.object_size = 4;
    length.dispatch_table = 0;
    length.value = 6;

    String string;
    string.class_tag = 4;
    string.object_size = 6;
    string.dispatch_table = 0;
    string.length = &length;
    assign_string_content(&string, "hello\n\0\0", 8);

    IO_out_string(&string);
    return 0;
}
