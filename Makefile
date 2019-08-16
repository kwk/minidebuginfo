all: gnu_debugdata

.PHONY: build
build:
	mkdir -p build && \
	cd build && \
	cmake ../source -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ && \
	cmake --build .

.PHONY: obj2yaml
obj2yaml: build
	mkdir -p yaml && \
	cd yaml && \
	cp ../build/myexe binary && \
	llvm-objcopy --remove-section=.rela.dyn --strip-symbol=crtstuff.c --strip-symbol=.gnu.build.attributes binary && \
	obj2yaml binary > binary.yaml && \
	yaml2obj binary.yaml > binary.reconstructed

.PHONY: gnu_debugdata
gnu_debugdata: obj2yaml
	cd yaml && \
	ln -s binary.reconstructed t
	ln -s ../header.yaml s
	cp t t.withoutsymtab && \
	llvm-objcopy --remove-section=.symtab t.withoutsymtab && \
	xz --force --keep t && \
	llvm-objcopy --add-section .gnu_debugdata=t.xz t.withoutsymtab && \
	lldb-test object-file t.withoutsymtab | FileCheck s
	

