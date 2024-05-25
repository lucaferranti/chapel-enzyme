use CTypes;

extern {
    double __enzyme_autodiff(void*, ...);
}

proc log1p_like_function(a: real): real { return 2 * a; }


var __enzyme_function_like: c_array(c_ptr(void), 2);
__enzyme_function_like[0] = c_ptrTo(log1p_like_function): c_ptr(void);
__enzyme_function_like[1] = c_ptrToConst("log1p"): c_ptr(void);

var grad_out = __enzyme_autodiff(c_ptrTo(log1p_like_function): c_ptr(void), 2.0);

writeln("Gradient of the log1p like function is ", grad_out);