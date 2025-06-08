#include <Python.h>

extern int multiply_asm(int a, int b);

static PyObject* py_multiply_asm(PyObject* self, PyObject* args) {
    int a, b;
    if (!PyArg_ParseTuple(args, "ii", &a, &b)) {
        return NULL;
    }
    int result = multiply_asm(a, b);
    return PyLong_FromLong(result);
}

static PyMethodDef methods[] = {
    {"multiply_asm", py_multiply_asm, METH_VARARGS, "Multiply two integers using assembly"},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef module = {
    PyModuleDef_HEAD_INIT, "myasm", NULL, -1, methods
};

PyMODINIT_FUNC PyInit_myasm(void) {
    return PyModule_Create(&module);
}
