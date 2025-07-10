typedef struct {
    int class_tag;
    int object_size;
    void* dispatch_table;
} Object;

extern Object* Object_abort(Object*);

int main() {
    Object object;
    Object_abort(&object); // expected: abort message

    return 0;
}
