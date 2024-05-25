use CTypes;

extern {
    struct Vector {
        double x1, x2, x3, x4;
    };
    extern struct Vector __enzyme_batch(void*, ...);
    extern int enzyme_width;
    extern int enzyme_vector;
    extern int enzyme_scalar;
}

proc square(x: real): real {return x * x;}

proc vecsquare(x1: real, x2: real, x3: real, x4: real) {
  return __enzyme_batch(c_ptrTo(square): c_ptr(void), enzyme_width, 4, enzyme_vector, x1, x2, x3, x4);
}

var result = vecsquare(23.1, 10.0, 100.0, 3.14);
writeln(result);