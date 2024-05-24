use CTypes;

extern {
    double __enzyme_autodiff(void*, ...); // reverse mode
    double __enzyme_fwddiff(void*, ...); // forward mode
    int enzyme_dup;
    int enzyme_dupnoneed;
    int enzyme_out;
    int enzyme_const;
}

// Warm-up scalar function 
writeln("Warm-up: scalar function f(x) = x^2");
writeln("-----------------------------------");
proc f(x: real): real { return x * x;}

var x1 = 5.0,
    dx1 = 1.0;

var df_forward = __enzyme_fwddiff(c_ptrTo(f): c_ptr(void), x1, dx1);
writeln("  Forward mode: f'(5.0) = ", df_forward);

var df_reverse = __enzyme_autodiff(c_ptrTo(f): c_ptr(void), x1);
writeln("  Reverse mode: f'(5.0) = ", df_reverse);

writeln("\nPass-by-value: MISO function g(x, y) = x * y + 1/y");
writeln("--------------------------------------------------");

proc g(x: real, y: real): real { return x * y + 1.0 / y;}

// forward mode

var x = 3.0,
    y = 2.0,
    dx = 1.0,
    dy = 1.0;

var dg_dx_forward = __enzyme_fwddiff(c_ptrTo(g): c_ptr(void), x, dx, enzyme_const, y),
    dg_dy_forward = __enzyme_fwddiff(c_ptrTo(g): c_ptr(void), enzyme_const, x, y, dy);

writeln("  Forward mode: dg/dx = ", dg_dx_forward, " dg/dy = ", dg_dy_forward);

// reverse mode

extern {
  struct double2 {double dx; double dy;};
  extern struct double2 __enzyme_autodiff2(void*, ...);
}

var dg = __enzyme_autodiff2(c_ptrTo(g): c_ptr(void), x, y);
writeln("  Revese mode: dg = ", dg);
