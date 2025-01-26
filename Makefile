CC=g++
CCFLAGS=-Wall -std=c++14 -g -fopenmp -ftree-vectorize -fopt-info-vec -march=armv8.5-a+sve2 -mtune=neoverse-v2 -I/tools/acfl/24.04/armpl-24.10.1_AmazonLinux-2_gcc/include -L/tools/acfl/24.04/armpl-24.10.1_AmazonLinux-2_gcc/lib -larmpl -lamath -lm
OPTILVL=-O2
SOURCES=BSM_32.cxx
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
