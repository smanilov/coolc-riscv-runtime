typedef struct {
    int class_tag;
    int object_size;
    void* dispatch_table;
} Object;

extern Object* Object_abort();

int main() {
    Object_abort(); // expected: abort message

    return 0;
}
