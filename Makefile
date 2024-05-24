all: simple_functions.o

clean:
	rm -rf *.o tmp

%.o: %.chpl
    # Chapel compilation phase
	chpl --no-infer-const-refs --driver-compilation-phase --driver-tmp-dir tmp $^

    # Enzyme pass
	opt tmp/chpl__module-opt1.bc -load-pass-plugin=/home/lferrant/Enzyme/enzyme/build/Enzyme/LLVMEnzyme-14.so -passes=enzyme -o tmp/chpl__module-opt1.ll -S

    # Optimize enzyme code
	opt tmp/chpl__module-opt1.ll -O2 -o tmp/chpl__module-opt1.ll -S

    # Convert to bc
	llvm-as tmp/chpl__module-opt1.ll -o tmp/chpl__module-opt1.bc

    # Finish Chapel compilation
	chpl --driver-makebinary-phase --driver-tmp-dir tmp $^ -o $@