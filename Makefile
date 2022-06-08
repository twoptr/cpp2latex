.PHONY: all
all: reflex bin/cpp2latex

COMMON_FLAGS = -Wall -Wshadow

# ----------------------------------------------------
# reflex dependencies:
INCLUDES := -I ~/pack/reflex/reflex-git/include
LIBS := ~/pack/reflex/reflex-git/lib/libreflex.a
# .-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-

INCLUDES += -I tmp

SRC := tmp/pcpp.cc
OBJ := build/$(subst tmp/,,$(SRC:.cc=.o))
DEP := $(OBJ:.o=.d)

define comp =
	@echo "Compiling: $< -> $@"
	@mkdir -p $(dir $@)
	g++ -c -MP -MMD $(CXXFLAGS) $(INCLUDES) $< -o $@
endef

build/%.o: tmp/%.cc
	$(comp)

define link =
	@echo "Linking: $@ from $^"
	@mkdir -p $(dir $@)
	g++ $(CXXFLAGS) $< $(LIBS) -o $@
endef

# === targets ==========================================================

tmp/pcpp.cc tmp/pcpp.h : src/parsecpp.rex
	mkdir -p tmp
	reflex --main $<

.PHONY: reflex
reflex: tmp/pcpp.cc tmp/pcpp.h

bin/cpp2latex: $(OBJ) reflex
	$(link)

.PHONY: example
example: bin/cpp2latex
	cat test/main.cc | bin/cpp2latex > test/main.cc.tex
	cat test/Euler14.h | bin/cpp2latex > test/Euler14.h.tex
	cat test/bench.cc | bin/cpp2latex > test/bench.cc.tex
	cat test/dbinit.cc | bin/cpp2latex > test/dbinit.cc.tex
	pdflatex -shell-escape test/doc.tex

.PHONY: clean
clean:
	@rm -rf tmp
	@rm -rf build
	@rm -rf bin
	@rm -f doc.*
	@rm -f test/*.h.tex
	@rm -f test/*.cc.tex
	@echo "Okay."

.PHONY: install
install:
	@sudo ln -s $(shell pwd)/bin/cpp2latex /usr/local/bin/cpp2latex
	@echo "Okay."

.PHONY: print
print:
	@echo "SRC: $(SRC)"
	@echo "OBJ: $(OBJ)"
	@echo "DEP: $(DEP)"

-include $(DEP_ALL)
