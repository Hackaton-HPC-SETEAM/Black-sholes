CC=g++
CCFLAGS1=-Wall -std=c++14 -g -fopenmp -ftree-vectorize -fopt-info-vec -lm
CCFLAGS2=-Wall -std=c++14 -g -fopenmp -ftree-vectorize -fopt-info-vec -march=armv8.5-a+sve2 -mtune=neoverse-v2 -I/tools/acfl/24.04/armpl-24.10.1_AmazonLinux-2_gcc/include -L/tools/acfl/24.04/armpl-24.10.1_AmazonLinux-2_gcc/lib -larmpl -lamath -lm
OPTILVL= -O2

# Versioned source files

SOURCES_V1=src/BSM_original_v1.cxx
SOURCES_V2=src/BSM_openmp_v2.cxx
SOURCES_V3=src/BSM_function_reorganized_v3.cxx
SOURCES_V4=src/BSM_mtune_armeneoverse_v4.cxx
SOURCES_V5=src/BSM_armpl_v5.cxx
SOURCES_V6_64=src/BSM_SIMD_v6_64.cxx
SOURCES_V6_32=src/BSM_SIMD_v6_32.cxx

# Versioned targets

TARGET_V1=BSM_v1
TARGET_V2=BSM_v2
TARGET_V3=BSM_v3
TARGET_V4=BSM_v4
TARGET_V5=BSM_v5
TARGET_V6_64=BSM_v6_64
TARGET_V6_32=BSM_v6_32

# Generate object files dynamically

OBJECTS_V1=$(SOURCES_V1:.cxx=.o)
OBJECTS_V2=$(SOURCES_V2:.cxx=.o)
OBJECTS_V3=$(SOURCES_V3:.cxx=.o)
OBJECTS_V4=$(SOURCES_V4:.cxx=.o)
OBJECTS_V5=$(SOURCES_V5:.cxx=.o)
OBJECTS_V6_64=$(SOURCES_V6_64:.cxx=.o)
OBJECTS_V6_32=$(SOURCES_V6_32:.cxx=.o)

# General rule for compiling the sources
%.o: %.cxx
	$(CC) $(CCFLAGS) -c $< -o $@

# Main targets
.PHONY: all clean

# Default target to compile all versions
all: $(TARGET_V1) $(TARGET_V2) $(TARGET_V3) $(TARGET_V4) $(TARGET_V5) $(TARGET_V6_64) $(TARGET_V6_32)

# Version-specific targets
$(TARGET_V0): $(OBJECTS_V0)
	$(CC) $(CCFLAGS1) $(OPTILVL) $^ -o $@

$(TARGET_V1): $(OBJECTS_V1)
	$(CC) $(CCFLAGS1) $(OPTILVL) $^ -o $@

$(TARGET_V2): $(OBJECTS_V2)
	$(CC) $(CCFLAGS1) $(OPTILVL) $^ -o $@

$(TARGET_V3): $(OBJECTS_V3)
	$(CC) $(CCFLAGS1) $(OPTILVL) $^ -o $@

$(TARGET_V4): $(OBJECTS_V4)
	$(CC) $(CCFLAGS2) $(OPTILVL) $^ -o $@

$(TARGET_V5): $(OBJECTS_V5)
	$(CC) $(CCFLAGS2) $(OPTILVL) $^ -o $@

$(TARGET_V6_64): $(OBJECTS_V6_64)
	$(CC) $(CCFLAGS2) $(OPTILVL) $^ -o $@

$(TARGET_V6_32): $(OBJECTS_V6_32)
	$(CC) $(CCFLAGS2) $(OPTILVL) $^ -o $@

# Clean rule to remove object files and binaries
clean:
	rm -f *.o $(TARGET_V0) $(TARGET_V1) $(TARGET_V2) $(TARGET_V3) $(TARGET_V4) $(TARGET_V5) $(TARGET_V6)
