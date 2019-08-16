all: yaml 

.PHONY: build
build:
	mkdir -p build && \
	cd build && \
	cmake ../source -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ && \
	cmake --build .

.PHONY: yaml
yaml: build
	mkdir -p yaml && \
	cd yaml && \
	cp ../build/myexe binary && \
	llvm-objcopy --strip-symbol=crtstuff.c --strip-symbol=.gnu.build.attributes binary && \
	obj2yaml binary > binary.yaml && \
	yaml2obj binary.yaml binary.reconstructed 
