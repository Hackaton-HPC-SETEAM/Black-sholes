CC=g++
CCFLAGS=-Wall -std=c99 -fopenmp
OPTILVL=-O2
LDFLAGS=-fopenmp
SOURCES=$(wildcard *.cxx)
OBJECTS=$(SOURCES:.c=.o)
TARGET=BSM

.PHONY: compile $(TARGET)

compile: $(TARGET)

$(TARGET): $(OBJECTS) $(CXXOBJECTS)
	$(CC) $(LDFLAGS) $(OPTILVL) $^ -o $@

clean:
	rm -f *.o $(TARGET)