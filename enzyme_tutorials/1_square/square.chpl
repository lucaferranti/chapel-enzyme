use CTypes;

extern {
  double __enzyme_autodiff(void*, ...);
}

proc square(x: real) {
  return x * x;
}

proc dsquare(x: real): real {

  return __enzyme_autodiff(c_ptrTo(square): c_ptr(void), x);
}


for i in 1..4 {
  writeln("x = ", i, " f(x) = ", square(i), " f'(x) = ", dsquare(i));
}

