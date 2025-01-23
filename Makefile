CC=g++
CCFLAGS=-Wall -g -std=c++23 -fopenmp -ftree-vectorize -fopt-info-vec -march=native -mtune=native -I/opt/arm/armpl_24.10_gcc/include -L/opt/arm/armpl_24.10_gcc/lib -larmpl -lamath -lm -I./pcg-cpp-0.98/include
OPTILVL=-O2
SOURCES=BSM.cxx
SOURCES_ORIGIN=BSM_original.cxx
OBJECTS=$(SOURCES:.c=.o)
TARGET=BSM
TARGET_ORIGIN=BSM_original

.PHONY: compileOpt $(TARGET)

compileOpt: $(TARGET)

compileV0: $(TARGET_ORIGIN)

$(TARGET): $(OBJECTS) $(CXXOBJECTS)
	$(CC) $(CCFLAGS) $(OPTILVL) $^ -o $@

$(TARGET_ORIGIN): $(OBJECTS) $(CXXOBJECTS)
	$(CC) $(OPTILVL) $^ -o $@

clean:
	rm -f *.o $(TARGET)
