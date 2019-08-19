all: final_yaml


# Build the binary
.PHONY: build
build:
	mkdir -p build && \
	cd build && \
	cmake ../source -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ && \
	cmake --build .

# Convert the binary to a YAML file that yaml2obj doesn't complain about,
# that's why I've removed some sections and symbols here and there.
.PHONY: obj2yaml
obj2yaml: build
	mkdir -p yaml && \
	cd yaml && \
	cp ../build/myexe binary && \
	llvm-objcopy --remove-section=.rela.dyn --strip-symbol=crtstuff.c --remove-section=.gnu.build.attributes binary && \
	obj2yaml binary > binary.yaml && \
	yaml2obj binary.yaml > binary.reconstructed

# Create the binary with the .gnu_debugdata section by executing the
# steps from the header.yaml file.
.PHONY: gnu_debugdata
gnu_debugdata: obj2yaml
	cd yaml && \
	cat ../header.yaml > %s && \
	cat binary.yaml >> %s && \
	echo "set -ex" > yaml.sh && \
	grep --regexp='#\s*RUN:\s*'  ../header.yaml | sed 's/#\s*RUN\:\s*//g' >> yaml.sh && \
	bash ./yaml.sh

# Produce the final YAML file 
.PHONY: final_yaml
final_yaml: gnu_debugdata
	cat header.yaml > final.yaml
	obj2yaml yaml/%t >> final.yaml
	yaml2obj final.yaml | llvm-readelf -WSs && echo "ALL DONE SEE final.yaml" || echo "AN ERROR OCCURED ^"

.PHONY: clean
clean:
	rm -rf build yaml final.yaml
	

