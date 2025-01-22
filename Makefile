CC=g++
CCFLAGS=-Wall -std=c++14 -fopenmp -ftree-vectorize -mtune=neoverse-v2 -fopt-info-vec
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
