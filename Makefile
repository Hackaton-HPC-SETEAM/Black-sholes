CC=g++
CCFLAGS=-Wall -std=c99 -fopenmp
OPTILVL=-O2
LDFLAGS=-fopenmp
SOURCES=BSM.cxx
SOURCES_ORIGIN=BSM_original.cxx
OBJECTS=$(SOURCES:.c=.o)
TARGET=BSM
TARGET_ORIGIN=BSM_origin

.PHONY: compileOpt $(TARGET)

compileOpt: $(TARGET)

compileV0: $(TARGET_ORIGIN)

$(TARGET): $(OBJECTS) $(CXXOBJECTS)
	$(CC) $(LDFLAGS) $(OPTILVL) $^ -o $@

$(TARGET_ORIGIN): $(OBJECTS) $(CXXOBJECTS)
	$(CC) $(OPTILVL) $^ -o $@

clean:
	rm -f *.o $(TARGET)